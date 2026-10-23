package com.hospital.aop;

import com.hospital.model.Bill;
import com.hospital.service.MonitoringService;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

@Aspect
@Component
public class BillingAuditAspect {

    private static final Logger log = LoggerFactory.getLogger(BillingAuditAspect.class);

    private final MonitoringService monitoringService;

    @Autowired
    public BillingAuditAspect(MonitoringService monitoringService) {
        this.monitoringService = monitoringService;
    }

    /**
     * Pointcut for Bill Generation operation
     */
    @Pointcut("execution(* com.hospital.service.BillingService.generateBill(..))")
    public void billGenerationPointcut() {}

    /**
     * Pointcut for Payment Processing operation
     */
    @Pointcut("execution(* com.hospital.service.BillingService.processPayment(..))")
    public void paymentProcessingPointcut() {}

    /**
     * Audit log after successful bill generation
     */
    @AfterReturning(pointcut = "billGenerationPointcut()", returning = "result")
    public void auditBillGeneration(JoinPoint joinPoint, Object result) {
        if (result instanceof Bill bill) {
            String details = String.format(
                    "Generated Invoice [%s] for Patient UHID: %s (%s). Total: Rs. %s, Paid: Rs. %s, Balance: Rs. %s, Status: %s",
                    bill.getBillNumber(),
                    bill.getPatientUhid(),
                    bill.getPatientName(),
                    bill.getTotalAmount(),
                    bill.getPaidAmount(),
                    bill.getBalanceAmount(),
                    bill.getPaymentStatus()
            );

            log.info("[AOP AUDIT] >>> BILLING OPERATION: {} | {}", "BILL_GENERATED", details);

            monitoringService.logAuditEvent(
                    "BILL_GENERATED",
                    "BILL",
                    bill.getBillNumber(),
                    details,
                    "BILLING_DESK"
            );
        }
    }

    /**
     * Audit log after payment processing
     */
    @AfterReturning(pointcut = "paymentProcessingPointcut() && args(billId, paymentAmount, paymentMode, remarks)",
                    argNames = "joinPoint,billId,paymentAmount,paymentMode,remarks", returning = "result")
    public void auditPaymentProcessing(JoinPoint joinPoint, Long billId, BigDecimal paymentAmount,
                                       String paymentMode, String remarks, Object result) {
        Boolean success = (Boolean) result;
        if (Boolean.TRUE.equals(success)) {
            String details = String.format(
                    "Recorded Payment of Rs. %s for Bill ID [%d] via Mode: [%s]. Remarks: %s",
                    paymentAmount,
                    billId,
                    paymentMode,
                    (remarks != null ? remarks : "N/A")
            );

            log.info("[AOP AUDIT] >>> PAYMENT OPERATION: {} | {}", "PAYMENT_PROCESSED", details);

            monitoringService.logAuditEvent(
                    "PAYMENT_PROCESSED",
                    "BILL",
                    String.valueOf(billId),
                    details,
                    "CASHIER"
            );
        }
    }
}
