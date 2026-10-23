<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Doctor Consultations - LifeCare Hospital" />
<c:set var="activePage" value="consultations" />
<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<div class="content-wrapper">
    <div class="container-fluid px-4 py-4">
        <!-- Header -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold mb-1 text-dark">
                    <i class="fa-solid fa-user-doctor text-primary me-2"></i>Doctor Consultations Registry
                </h3>
                <p class="text-muted mb-0">Record and track outpatient consultations, prescriptions, doctor diagnoses, and consultation fees.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/consultations/new" class="btn btn-primary shadow-sm">
                    <i class="fa-solid fa-stethoscope me-1"></i> Record New Consultation
                </a>
            </div>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="card card-custom">
            <div class="card-header bg-transparent py-3">
                <span class="fw-bold text-dark">Clinical Consultations (${consultations.size()})</span>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Date & Time</th>
                                <th>Patient Details</th>
                                <th>Attending Doctor</th>
                                <th>Reported Symptoms</th>
                                <th>Clinical Diagnosis</th>
                                <th>Prescription & Advise</th>
                                <th class="text-end">Fee</th>
                                <th class="text-center">Billing Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${consultations}">
                                <tr>
                                    <td>
                                        <fmt:formatDate value="${c.consultationDate}" pattern="dd-MMM-yyyy, HH:mm" />
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/patients/view/${c.patientId}" class="fw-bold text-dark text-decoration-none">
                                            ${c.patientName}
                                        </a>
                                        <span class="badge bg-light text-secondary border d-block mt-1" style="width: fit-content;">${c.patientUhid}</span>
                                    </td>
                                    <td>
                                        <div class="fw-semibold text-primary">${c.doctorName}</div>
                                        <small class="text-muted">${c.doctorSpecialization}</small>
                                    </td>
                                    <td>
                                        <span class="text-muted" style="font-size: 0.88rem;">${c.symptoms}</span>
                                    </td>
                                    <td>
                                        <span class="badge bg-info-subtle text-info border border-info-subtle text-wrap text-start">
                                            ${c.diagnosis}
                                        </span>
                                    </td>
                                    <td>
                                        <code class="text-dark bg-light px-2 py-1 rounded d-inline-block">${c.prescription}</code>
                                    </td>
                                    <td class="text-end fw-bold text-dark">
                                        ₹<fmt:formatNumber value="${c.consultationFee}" minFractionDigits="2"/>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge ${c.status == 'BILLED' ? 'badge-status-completed' : 'bg-warning-subtle text-warning'} px-2 py-1">
                                            ${c.status}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty consultations}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="fa-solid fa-stethoscope fs-2 d-block mb-2 text-secondary"></i>
                                        No consultations recorded yet.
                                    </td>
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
