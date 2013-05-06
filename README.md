nonbinding-issue
================

To reproduce issue:

Build the module:

  cd nonbinding-issue/lib
  export JBOSS_HOME=<INSERT HERE>
  chmod +x ./bin/deploy-module.sh
  ./bin/deploy-module.sh

This will build a jar containing an interceptor binding. The jar is then installed into the module root of your $JBOSS_HOME as "org.myinterceptor".

Start Wildfly:

  cd $JBOSS_HOME
  ./bin/standalone.sh

Run test:

  cd nonbinding-issue/impl
  mvn clean install -Parq-remote

Observe:

  11:12:33,932 ERROR [org.jboss.as.controller.management-operation] (management-handler-thread - 2) JBAS014613: Operation ("deploy") failed - address: ([("deployment" => "test.jar")]) - failure description: {"JBAS014671: Failed services" => {"jboss.deployment.unit.\"test.jar\".WeldStartService" => "org.jboss.msc.service.StartException in service jboss.deployment.unit.\"test.jar\".WeldStartService: Failed to start service
    Caused by: java.lang.ClassCastException: org.jboss.weld.exceptions.DefinitionException cannot be cast to org.jboss.weld.exceptions.WeldException"}}
11:12:33,934 ERROR [org.jboss.as.server] (management-handler-thread - 2) JBAS015870: Deploy of deployment "test.jar" was rolled back with the following failure message: 
{"JBAS014671: Failed services" => {"jboss.deployment.unit.\"test.jar\".WeldStartService" => "org.jboss.msc.service.StartException in service jboss.deployment.unit.\"test.jar\".WeldStartService: Failed to start service
    Caused by: java.lang.ClassCastException: org.jboss.weld.exceptions.DefinitionException cannot be cast to org.jboss.weld.exceptions.WeldException"}}

If you put a breakpoint on org.jboss.weld.metadata.cache.MetaAnnotationStore#L199 you will see that the root cause of the exception is:

  org.jboss.weld.exceptions.DefinitionException: WELD-001101 Member of array type or annotation type must be annotated @NonBinding:  [EnhancedAnnotatedMethodImpl] public abstract org.my.lib.MyInterceptor.myMethod()

Notice that the @Nonbinding annotation cannot be found, even though it exists on the interceptor binding.

This problem only seems to occur if you obtain the Interceptor binding via a WildFly module. It doesn't occur if the Interceptor Binding class is co-located with the test code, or imported using ShrinkWrap maven resolver.

