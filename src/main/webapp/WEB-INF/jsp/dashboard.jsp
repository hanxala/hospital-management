<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Dashboard - LifeCare Hospital" />
<c:set var="activePage" value="dashboard" />
<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<div class="content-wrapper">
    <div class="container-fluid px-4 py-4">
        <!-- Top Welcome Header -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold mb-1 text-dark">
                    <i class="fa-solid fa-hospital text-primary me-2"></i>Executive Medical Dashboard
                </h3>
                <p class="text-muted mb-0">Overview of patient registrations, medical consultations, diagnostic lab charges, and billing streams.</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/patients/register" class="btn btn-primary shadow-sm">
                    <i class="fa-solid fa-user-plus me-1"></i> Register Patient
                </a>
                <a href="${pageContext.request.contextPath}/billing/new" class="btn btn-outline-primary shadow-sm">
                    <i class="fa-solid fa-file-invoice me-1"></i> Create Bill
                </a>
            </div>
        </div>

        <!-- Metric KPI Cards -->
        <div class="row g-3 mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="card card-custom stat-card h-100" style="border-left-color: #2563eb;">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-muted text-uppercase fw-semibold" style="font-size: 0.75rem;">Total Registered Patients</span>
                            <h2 class="fw-bold mb-0 mt-1 text-dark">${stats.totalPatients}</h2>
                            <small class="text-success"><i class="fa-solid fa-arrow-up me-1"></i>Active EHR Records</small>
                        </div>
                        <div class="p-3 bg-primary-subtle text-primary rounded-circle">
                            <i class="fa-solid fa-users fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-md-6">
                <div class="card card-custom stat-card h-100" style="border-left-color: #0d9488;">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-muted text-uppercase fw-semibold" style="font-size: 0.75rem;">Consultations & Lab Tests</span>
                            <h2 class="fw-bold mb-0 mt-1 text-dark">${stats.totalConsultations + stats.totalLabOrders}</h2>
                            <small class="text-muted">${stats.totalConsultations} Consults | ${stats.totalLabOrders} Tests</small>
                        </div>
                        <div class="p-3 bg-info-subtle text-info rounded-circle">
                            <i class="fa-solid fa-stethoscope fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-md-6">
                <div class="card card-custom stat-card h-100" style="border-left-color: #10b981;">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-muted text-uppercase fw-semibold" style="font-size: 0.75rem;">Total Revenue Collected</span>
                            <h2 class="fw-bold mb-0 mt-1 text-success">
                                ₹<fmt:formatNumber value="${stats.totalRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                            </h2>
                            <small class="text-muted">From ${stats.totalBills} Invoices</small>
                        </div>
                        <div class="p-3 bg-success-subtle text-success rounded-circle">
                            <i class="fa-solid fa-indian-rupee-sign fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-md-6">
                <div class="card card-custom stat-card h-100" style="border-left-color: #f59e0b;">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-muted text-uppercase fw-semibold" style="font-size: 0.75rem;">Pending Receivables</span>
                            <h2 class="fw-bold mb-0 mt-1 text-warning">
                                ₹<fmt:formatNumber value="${stats.pendingBalance}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                            </h2>
                            <small class="text-danger">${stats.unpaidBills} Invoices Pending</small>
                        </div>
                        <div class="p-3 bg-warning-subtle text-warning rounded-circle">
                            <i class="fa-solid fa-clock-rotate-left fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Module Navigation Cards -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/patients" class="text-decoration-none">
                    <div class="card card-custom p-3 text-center h-100 border-0 bg-white">
                        <i class="fa-solid fa-user-injured text-primary fs-2 mb-2"></i>
                        <h6 class="fw-bold text-dark mb-1">Patient Desk</h6>
                        <small class="text-muted">Register, edit & view patient histories</small>
                    </div>
                </a>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/consultations/new" class="text-decoration-none">
                    <div class="card card-custom p-3 text-center h-100 border-0 bg-white">
                        <i class="fa-solid fa-stethoscope text-info fs-2 mb-2"></i>
                        <h6 class="fw-bold text-dark mb-1">Doctor Consultation</h6>
                        <small class="text-muted">Assign doctor, record diagnosis & rx</small>
                    </div>
                </a>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/lab" class="text-decoration-none">
                    <div class="card card-custom p-3 text-center h-100 border-0 bg-white">
                        <i class="fa-solid fa-vial-virus text-success fs-2 mb-2"></i>
                        <h6 class="fw-bold text-dark mb-1">Laboratory Orders</h6>
                        <small class="text-muted">Order tests, review fees & report results</small>
                    </div>
                </a>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/aop-monitor" class="text-decoration-none">
                    <div class="card card-custom p-3 text-center h-100 border-0 bg-white">
                        <i class="fa-solid fa-shield-halved text-warning fs-2 mb-2"></i>
                        <h6 class="fw-bold text-dark mb-1">AOP Monitor</h6>
                        <small class="text-muted">Audit logs & service execution times</small>
                    </div>
                </a>
            </div>
        </div>

        <!-- Two Column Content: Invoices & AOP Audit Stream -->
        <div class="row g-4">
            <!-- Recent Invoices -->
            <div class="col-lg-7">
                <div class="card card-custom h-100">
                    <div class="card-header bg-transparent py-3 d-flex justify-content-between align-items-center">
                        <h5 class="fw-bold mb-0 text-dark">
                            <i class="fa-solid fa-file-invoice-dollar text-primary me-2"></i>Recent Hospital Invoices
                        </h5>
                        <a href="${pageContext.request.contextPath}/billing" class="btn btn-sm btn-outline-secondary">View All</a>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover table-custom align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Bill #</th>
                                        <th>Patient</th>
                                        <th>Date</th>
                                        <th class="text-end">Total Amount</th>
                                        <th class="text-center">Status</th>
                                        <th class="text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${recentBills}" begin="0" end="5">
                                        <tr>
                                            <td>
                                                <span class="fw-bold text-primary">${b.billNumber}</span>
                                            </td>
                                            <td>
                                                <div class="fw-semibold text-dark">${b.patientName}</div>
                                                <small class="text-muted">${b.patientUhid}</small>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${b.billingDate}" pattern="dd MMM yyyy, HH:mm" />
                                            </td>
                                            <td class="text-end fw-bold text-dark">
                                                ₹<fmt:formatNumber value="${b.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${b.paymentStatus == 'PAID'}">
                                                        <span class="badge badge-status-paid px-2 py-1">PAID</span>
                                                    </c:when>
                                                    <c:when test="${b.paymentStatus == 'PARTIAL'}">
                                                        <span class="badge badge-status-partial px-2 py-1">PARTIAL</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-status-unpaid px-2 py-1">UNPAID</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/billing/invoice/${b.billNumber}" class="btn btn-sm btn-outline-primary" title="View Printable Invoice">
                                                    <i class="fa-solid fa-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty recentBills}">
                                        <tr>
                                            <td colspan="6" class="text-center py-4 text-muted">No billing records found.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- AOP Real-time Audit & Monitoring Activity -->
            <div class="col-lg-5">
                <div class="card card-custom h-100">
                    <div class="card-header bg-transparent py-3 d-flex justify-content-between align-items-center">
                        <h5 class="fw-bold mb-0 text-dark">
                            <i class="fa-solid fa-shield-cat text-warning me-2"></i>AOP Live Billing Audit
                        </h5>
                        <a href="${pageContext.request.contextPath}/aop-monitor" class="btn btn-sm btn-outline-warning">AOP Full View</a>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-light border d-flex align-items-center py-2 px-3 mb-3" style="font-size: 0.85rem;">
                            <i class="fa-solid fa-bolt text-warning me-2 fs-5"></i>
                            <div>
                                Intercepted by Spring AOP <strong>@Aspect BillingAuditAspect</strong>. Persisted using <strong>Spring JDBC</strong>.
                            </div>
                        </div>

                        <ul class="list-group list-group-flush">
                            <c:forEach var="log" items="${recentAuditLogs}">
                                <li class="list-group-item px-0 py-2 border-bottom">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <span class="badge bg-primary-subtle text-primary fw-bold" style="font-size: 0.72rem;">${log.action}</span>
                                            <span class="text-dark fw-semibold ms-1" style="font-size: 0.85rem;">${log.entityId}</span>
                                        </div>
                                        <small class="text-muted" style="font-size: 0.72rem;">
                                            <fmt:formatDate value="${log.timestamp}" pattern="HH:mm:ss" />
                                        </small>
                                    </div>
                                    <p class="mb-0 text-muted mt-1" style="font-size: 0.8rem; line-height: 1.3;">
                                        ${log.details}
                                    </p>
                                    <small class="text-secondary" style="font-size: 0.7rem;">
                                        <i class="fa-solid fa-user-shield me-1"></i>By: ${log.performedBy}
                                    </small>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<jsp:include page="common/footer.jsp" />
