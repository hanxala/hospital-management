package com.hospital.aop;

import com.hospital.service.MonitoringService;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class ServicePerformanceAspect {

    private static final Logger log = LoggerFactory.getLogger(ServicePerformanceAspect.class);

    private final MonitoringService monitoringService;

    @Value("${hospital.performance.threshold-ms:20}")
    private long thresholdMs;

    @Autowired
    public ServicePerformanceAspect(MonitoringService monitoringService) {
        this.monitoringService = monitoringService;
    }

    /**
     * Pointcut targeting all hospital service methods, excluding MonitoringService itself to avoid recursion.
     */
    @Pointcut("execution(* com.hospital.service..*(..)) && !execution(* com.hospital.service.MonitoringService..*(..))")
    public void monitoredServiceMethods() {}

    @Around("monitoredServiceMethods()")
    public Object monitorExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        String className = joinPoint.getTarget().getClass().getSimpleName();
        String methodName = joinPoint.getSignature().getName();

        long startTime = System.currentTimeMillis();
        Object result;
        try {
            result = joinPoint.proceed();
        } catch (Throwable ex) {
            long duration = System.currentTimeMillis() - startTime;
            log.error("[AOP MONITOR] Method {}.{} threw exception after {} ms: {}",
                    className, methodName, duration, ex.getMessage());
            throw ex;
        }

        long duration = System.currentTimeMillis() - startTime;
        boolean exceeded = duration > thresholdMs;

        if (exceeded) {
            log.warn("[AOP MONITOR] SLOW SERVICE ALERT: {}.{} executed in {} ms (Threshold: {} ms)",
                    className, methodName, duration, thresholdMs);
        } else {
            log.debug("[AOP MONITOR] {}.{} executed in {} ms", className, methodName, duration);
        }

        try {
            monitoringService.recordExecutionMetric(className, methodName, duration, exceeded);
        } catch (Exception e) {
            log.error("Failed to persist performance log: {}", e.getMessage());
        }

        return result;
    }
}
