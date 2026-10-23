<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Patient Profile - ${patient.fullName}" />
<c:set var="activePage" value="patients" />
<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<div class="content-wrapper">
    <div class="container-fluid px-4 py-4">

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Top Profile Banner -->
        <div class="card card-custom mb-4 border-primary">
            <div class="card-body p-4">
                <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
                    <div class="d-flex align-items-center gap-3">
                        <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center" style="width: 64px; height: 64px; font-size: 1.75rem;">
                            <i class="fa-solid fa-user-injured"></i>
                        </div>
                        <div>
                            <div class="d-flex align-items-center gap-2">
                                <h3 class="fw-bold mb-0 text-dark">${patient.fullName}</h3>
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle fs-6">${patient.patientUhid}</span>
                                <span class="badge ${patient.status == 'ACTIVE' ? 'bg-success-subtle text-success' : 'bg-secondary'}">${patient.status}</span>
                            </div>
                            <div class="text-muted mt-1">
                                <span><i class="fa-solid fa-cake-candles me-1"></i>${patient.age} Years, ${patient.gender}</span>
                                <span class="mx-2">•</span>
                                <span><i class="fa-solid fa-droplet text-danger me-1"></i>Blood Group: <strong>${patient.bloodGroup}</strong></span>
                                <span class="mx-2">•</span>
                                <span><i class="fa-solid fa-phone me-1"></i>${patient.phone}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Clinical Actions -->
                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/consultations/new?patientId=${patient.id}" class="btn btn-outline-primary">
                            <i class="fa-solid fa-stethoscope me-1"></i> Add Consultation
                        </a>
                        <a href="${pageContext.request.contextPath}/lab/order?patientId=${patient.id}" class="btn btn-outline-info">
                            <i class="fa-solid fa-vial me-1"></i> Order Lab Test
                        </a>
                        <a href="${pageContext.request.contextPath}/billing/new?patientId=${patient.id}" class="btn btn-success">
                            <i class="fa-solid fa-file-invoice-dollar me-1"></i> Generate Bill
                        </a>
                        <a href="${pageContext.request.contextPath}/patients/edit/${patient.id}" class="btn btn-outline-secondary">
                            <i class="fa-solid fa-pen me-1"></i> Edit
                        </a>
                    </div>
                </div>

                <div class="row mt-4 pt-3 border-top g-3">
                    <div class="col-md-4">
                        <small class="text-muted d-block fw-semibold">Email Address</small>
                        <span>${patient.email != null ? patient.email : 'N/A'}</span>
                    </div>
                    <div class="col-md-4">
                        <small class="text-muted d-block fw-semibold">Residential Address</small>
                        <span>${patient.address != null ? patient.address : 'N/A'}</span>
                    </div>
                    <div class="col-md-4">
                        <small class="text-muted d-block fw-semibold">Emergency Contact</small>
                        <span>${patient.emergencyContact != null ? patient.emergencyContact : 'N/A'}</span>
                    </div>
                    <div class="col-12 mt-2">
                        <small class="text-muted d-block fw-semibold">Medical History & Allergies</small>
                        <p class="mb-0 text-dark bg-light p-2 rounded border" style="font-size: 0.9rem;">
                            ${not empty patient.medicalHistory ? patient.medicalHistory : 'No past medical conditions or chronic diseases reported.'}
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Consultations History Section -->
        <div class="card card-custom mb-4">
            <div class="card-header bg-transparent py-3 d-flex justify-content-between align-items-center">
                <h5 class="fw-bold mb-0 text-dark">
                    <i class="fa-solid fa-user-doctor text-primary me-2"></i>Doctor Consultations (${consultations.size()})
                </h5>
                <a href="${pageContext.request.contextPath}/consultations/new?patientId=${patient.id}" class="btn btn-sm btn-outline-primary">
                    <i class="fa-solid fa-plus me-1"></i> New Consultation
                </a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Doctor</th>
                                <th>Diagnosis</th>
                                <th>Prescription</th>
                                <th class="text-end">Fee</th>
                                <th class="text-center">Billing Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${consultations}">
                                <tr>
                                    <td><fmt:formatDate value="${c.consultationDate}" pattern="dd-MMM-yyyy, HH:mm" /></td>
                                    <td>
                                        <div class="fw-bold">${c.doctorName}</div>
                                        <small class="text-muted">${c.doctorSpecialization}</small>
                                    </td>
                                    <td><span class="text-dark fw-medium">${c.diagnosis}</span></td>
                                    <td><code>${c.prescription}</code></td>
                                    <td class="text-end fw-bold">₹<fmt:formatNumber value="${c.consultationFee}" minFractionDigits="2"/></td>
                                    <td class="text-center">
                                        <span class="badge ${c.status == 'BILLED' ? 'badge-status-completed' : 'bg-warning-subtle text-warning'}">
                                            ${c.status}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty consultations}">
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">No consultations on record for this patient.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Laboratory Orders Section -->
        <div class="card card-custom mb-4">
            <div class="card-header bg-transparent py-3 d-flex justify-content-between align-items-center">
                <h5 class="fw-bold mb-0 text-dark">
                    <i class="fa-solid fa-microscope text-info me-2"></i>Diagnostic Laboratory Tests (${labOrders.size()})
                </h5>
                <a href="${pageContext.request.contextPath}/lab/order?patientId=${patient.id}" class="btn btn-sm btn-outline-info">
                    <i class="fa-solid fa-plus me-1"></i> Order Test
                </a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Order Date</th>
                                <th>Test Code & Name</th>
                                <th>Category</th>
                                <th>Results / Findings</th>
                                <th class="text-end">Fee</th>
                                <th class="text-center">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="l" items="${labOrders}">
                                <tr>
                                    <td><fmt:formatDate value="${l.orderDate}" pattern="dd-MMM-yyyy" /></td>
                                    <td>
                                        <span class="fw-bold">${l.testName}</span>
                                        <span class="badge bg-light text-dark border ms-1">${l.testCode}</span>
                                    </td>
                                    <td><span class="badge bg-secondary-subtle text-secondary">${l.testCategory}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty l.resultSummary}">
                                                <small class="text-success"><i class="fa-solid fa-check me-1"></i>${l.resultSummary}</small>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted fst-italic">Pending technician entry</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end fw-bold">₹<fmt:formatNumber value="${l.labFee}" minFractionDigits="2"/></td>
                                    <td class="text-center">
                                        <span class="badge ${l.status == 'COMPLETED' ? 'badge-status-completed' : (l.status == 'BILLED' ? 'bg-primary-subtle text-primary' : 'bg-warning-subtle text-warning')}">
                                            ${l.status}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty labOrders}">
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">No diagnostic laboratory orders recorded.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Billing Invoices Section -->
        <div class="card card-custom">
            <div class="card-header bg-transparent py-3 d-flex justify-content-between align-items-center">
                <h5 class="fw-bold mb-0 text-dark">
                    <i class="fa-solid fa-receipt text-success me-2"></i>Invoices & Billing History (${bills.size()})
                </h5>
                <a href="${pageContext.request.contextPath}/billing/new?patientId=${patient.id}" class="btn btn-sm btn-success">
                    <i class="fa-solid fa-file-invoice me-1"></i> Generate Bill
                </a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Invoice #</th>
                                <th>Date</th>
                                <th class="text-end">Total Amount</th>
                                <th class="text-end">Paid Amount</th>
                                <th class="text-end">Balance Due</th>
                                <th class="text-center">Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${bills}">
                                <tr>
                                    <td><span class="fw-bold text-primary">${b.billNumber}</span></td>
                                    <td><fmt:formatDate value="${b.billingDate}" pattern="dd-MMM-yyyy" /></td>
                                    <td class="text-end fw-bold">₹<fmt:formatNumber value="${b.totalAmount}" minFractionDigits="2"/></td>
                                    <td class="text-end text-success fw-bold">₹<fmt:formatNumber value="${b.paidAmount}" minFractionDigits="2"/></td>
                                    <td class="text-end text-danger fw-bold">₹<fmt:formatNumber value="${b.balanceAmount}" minFractionDigits="2"/></td>
                                    <td class="text-center">
                                        <span class="badge ${b.paymentStatus == 'PAID' ? 'badge-status-paid' : (b.paymentStatus == 'PARTIAL' ? 'badge-status-partial' : 'badge-status-unpaid')}">
                                            ${b.paymentStatus}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/billing/invoice/${b.billNumber}" class="btn btn-sm btn-outline-primary">
                                            <i class="fa-solid fa-file-lines me-1"></i> View Receipt
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty bills}">
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">No billing invoices generated yet.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</div>

<jsp:include page="common/footer.jsp" />
