<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="AOP Audit & Performance Monitor - LifeCare Hospital" />
<c:set var="activePage" value="aop" />
<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<div class="content-wrapper">
    <div class="container-fluid px-4 py-4">
        <!-- Header -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold mb-1 text-dark">
                    <i class="fa-solid fa-shield-halved text-warning me-2"></i>Spring AOP Audit & Performance Monitoring Console
                </h3>
                <p class="text-muted mb-0">Live non-intrusive aspect interception for billing auditing and service execution latency analysis.</p>
            </div>
            <div class="d-flex align-items-center gap-2">
                <span class="badge bg-warning-subtle text-dark border border-warning px-3 py-2">
                    <i class="fa-solid fa-stopwatch me-1"></i> Threshold: ${thresholdMs} ms
                </span>
                <a href="${pageContext.request.contextPath}/aop-monitor" class="btn btn-outline-primary">
                    <i class="fa-solid fa-arrows-rotate me-1"></i> Refresh Logs
                </a>
            </div>
        </div>

        <!-- Architectural Banner -->
        <div class="row g-3 mb-4">
            <div class="col-md-6">
                <div class="card card-custom p-3 border-start border-4 border-warning h-100">
                    <div class="d-flex gap-3">
                        <div class="p-3 bg-warning-subtle text-warning rounded-circle align-self-start">
                            <i class="fa-solid fa-clipboard-check fs-3"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold text-dark mb-1">Billing Audit Aspect (BillingAuditAspect.java)</h6>
                            <p class="text-muted small mb-1">
                                Intercepts <code>BillingService.generateBill(..)</code> and <code>BillingService.processPayment(..)</code> using <strong>@AfterReturning</strong> advice.
                            </p>
                            <span class="badge bg-light text-secondary border">Records stored via Spring JDBC in <code>audit_logs</code></span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card card-custom p-3 border-start border-4 border-info h-100">
                    <div class="d-flex gap-3">
                        <div class="p-3 bg-info-subtle text-info rounded-circle align-self-start">
                            <i class="fa-solid fa-gauge-high fs-3"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold text-dark mb-1">Execution Time Monitor (ServicePerformanceAspect.java)</h6>
                            <p class="text-muted small mb-1">
                                Wraps service methods with <strong>@Around</strong> advice using <code>ProceedingJoinPoint</code> to measure millisecond execution times.
                            </p>
                            <span class="badge bg-light text-secondary border">Flags execution exceeding ${thresholdMs}ms into <code>performance_logs</code></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabbed or Split Views -->
        <div class="row g-4">
            <!-- Billing Audit Trail -->
            <div class="col-lg-6">
                <div class="card card-custom h-100">
                    <div class="card-header bg-transparent py-3 d-flex justify-content-between align-items-center">
                        <h5 class="fw-bold text-dark mb-0">
                            <i class="fa-solid fa-shield-cat text-primary me-2"></i>AOP Billing Audit Trail (${auditLogs.size()})
                        </h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover table-custom align-middle mb-0" style="font-size: 0.85rem;">
                                <thead>
                                    <tr>
                                        <th>Timestamp</th>
                                        <th>Action</th>
                                        <th>Entity Ref</th>
                                        <th>Details</th>
                                        <th>User</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="log" items="${auditLogs}">
                                        <tr>
                                            <td class="text-muted" style="white-space: nowrap;">
                                                <fmt:formatDate value="${log.timestamp}" pattern="HH:mm:ss" />
                                            </td>
                                            <td>
                                                <span class="badge ${log.action == 'BILL_GENERATED' ? 'bg-primary-subtle text-primary' : 'bg-success-subtle text-success'}">
                                                    ${log.action}
                                                </span>
                                            </td>
                                            <td class="fw-bold text-dark">${log.entityId}</td>
                                            <td><span class="text-secondary">${log.details}</span></td>
                                            <td><span class="badge bg-light text-dark border">${log.performedBy}</span></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty auditLogs}">
                                        <tr>
                                            <td colspan="5" class="text-center py-4 text-muted">No audit logs recorded yet.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Service Execution Performance -->
            <div class="col-lg-6">
                <div class="card card-custom h-100">
                    <div class="card-header bg-transparent py-3 d-flex justify-content-between align-items-center">
                        <h5 class="fw-bold text-dark mb-0">
                            <i class="fa-solid fa-stopwatch-20 text-info me-2"></i>Service Execution Time Monitor (${performanceLogs.size()})
                        </h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover table-custom align-middle mb-0" style="font-size: 0.85rem;">
                                <thead>
                                    <tr>
                                        <th>Timestamp</th>
                                        <th>Service Class</th>
                                        <th>Invoked Method</th>
                                        <th class="text-end">Execution Time</th>
                                        <th class="text-center">Latency Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="perf" items="${performanceLogs}">
                                        <tr>
                                            <td class="text-muted" style="white-space: nowrap;">
                                                <fmt:formatDate value="${perf.timestamp}" pattern="HH:mm:ss" />
                                            </td>
                                            <td><code>${perf.className}</code></td>
                                            <td class="fw-semibold text-dark">${perf.methodName}()</td>
                                            <td class="text-end fw-bold">
                                                ${perf.executionTimeMs} ms
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${perf.thresholdExceeded}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger">
                                                            <i class="fa-solid fa-triangle-exclamation me-1"></i> Slow (&gt;${thresholdMs}ms)
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-success-subtle text-success">
                                                            <i class="fa-solid fa-bolt me-1"></i> Optimal
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty performanceLogs}">
                                        <tr>
                                            <td colspan="5" class="text-center py-4 text-muted">No execution metrics collected yet.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<jsp:include page="common/footer.jsp" />
