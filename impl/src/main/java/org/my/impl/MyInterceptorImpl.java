package org.my.impl;

import org.my.lib.MyInterceptor;

import javax.interceptor.AroundInvoke;
import javax.interceptor.Interceptor;
import javax.interceptor.InvocationContext;

/**
 * @author paul.robinson@redhat.com 02/05/2013
 */
@Interceptor
@MyInterceptor
public class MyInterceptorImpl {

    @AroundInvoke
    public Object intercept(InvocationContext ic) throws Exception {
        return ic.proceed();
    }
}