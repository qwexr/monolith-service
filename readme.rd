 声明：
  本人提供这个 SpringMVC + Mybatis + Redis 的Demo 本着学习的态度，如果有欠缺和不足的地方，给予指正，并且多多包涵.
	
框架使用环境：
  Maven:3.3.9	
  Eclipse:Oxygen
  JDK:1.8    	
  Tomcat:8.0.36
    
框架包含内容：

  一、权限控制
    说在前面：
    本系统权限灵感来自于Shiro，Shiro的强大无需言表，但我始终坚信一点适合自己项目和使用习惯的东西才是好东西，深入了解你就会发现不管是Shiro还是Spring Security其实都是基于
     RBAC(Role-Based Access Control)这种模型来实现的访问控制，对于我项目日常用到的权限控制，Shiro实在是有点大材小用，也许以后随着项目逐渐强大可能会引入，也或者自己会去封装。
     这里就不再讨论了，现在框架用到的也是基于RBAC模型来实现的访问控制。
     本系统则采用一个注解加拦截器模式来控制
     @RequiresAuthentication
     	value:对应权限值
     	level:对应级别 role、permission、operation
     	ignore:是否忽略校验 默认为false
     	authc:是否只做登录鉴权 默认false
    注解全作用于方法上
    至于实现思路很简单，利用拦截器接管所有请求，然后根据用户携带的token(登录时会返回一个token作为用户的合法令牌)从缓存中获取用户信息并从数据库加载出改用户的角色和权限数据然
    后根据反射获取访问该方法的注解的值比较是否满足 满足则继续执行 不满足则提示相关操作无权限之类的，这里我是把权限信息首次加载后放入缓存，系统内的高热点数据建议大家都放入缓
    存效率高得多，然后有地方修改对应用户的权限时清除改用户的权限缓存，具体的请参照Spring Cache这里完全把Redis和Spring Cache结合在一起了 完全不需要代码来操作redis(除了业务中需
    要特殊处理的东西)
    
  二、日志异常提醒
    日志采用的是slf4j+logback,对比log4j它的优势还是十分明显，具体资料可以自行百度！
    日志我除了控制台打印的之外，其他对INFO、WARN、ERROR三种日志进行了分类操作 每种日志分类写入并按天分割
    然后对于错误级别及以上日志进行了特殊处理，发生错误及以上级别的日志都会进行邮件提醒,而且自定义了邮件发送的触发器，具体请看源码
 
  三、Spring+Redis整合
    这里就就是采用了Spring-Data-Redis插件然后和Spring Cache无缝衔接并同时实现类似于Ehcache的闲置时间功能，具体实现请参照jedis项目。同时封装了几个方法用于实现单用户登录功能。
       
  四、RSA分段加密
    RSA加密目前是Java中加密规格最高的东西了，项目中提供了RSA加密解密的工具类（tools项目内），同时实现了RSA的分段加密解密，破除了RSA单次加密解密的长度限制，为何将这个点单独
   列出来，主要是因为项目中有很多场景可以使用RSA。例如：文件服务器的安全控制
    
  五、实体类校验
   采用的是Hibernate Validator校验，但是它使用都尼玛要在方法中每个都去判断，这对我这类懒得XX的人来说肯定受不了，于是就用拦截器统一处理了，具体参照aop内配置
    
  六、自动分页
   集成pagehelper分页插件，这里不多介绍
    
  八、多数据源配置
    系统还实现了多数据源配置，使用起来可能会让你觉得异常简单，自定义了一个注解@DataSource 里面只需要填数据源名称就能切换了，可作用于类、方法上，还有就是提供了DataSourceContextHolder类，里面有相应方法可以在
    业务逻辑中随时切换数据源 他们之前的优先级关系是DataSourceContextHolder>@DataSource(方法)>@DataSource(类)
    
  九、其他
	其他包含了全局异常处理、定时任务、邮件服务器等功能