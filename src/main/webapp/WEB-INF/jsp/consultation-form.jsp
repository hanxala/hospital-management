<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Record Consultation - LifeCare Hospital" />
<c:set var="activePage" value="consultations" />
<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<div class="content-wrapper">
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3 class="fw-bold text-dark mb-1">
                            <i class="fa-solid fa-stethoscope text-primary me-2"></i>Record Doctor Consultation
                        </h3>
                        <p class="text-muted mb-0">Record outpatient consultation, doctor findings, prescription, and standard fee.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/consultations" class="btn btn-outline-secondary">
                        <i class="fa-solid fa-arrow-left me-1"></i> Back
                    </a>
                </div>

                <div class="card card-custom p-4">
                    <form action="${pageContext.request.contextPath}/consultations/save" method="post">
                        <div class="row g-3">
                            <!-- Select Patient -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Patient <span class="text-danger">*</span></label>
                                <select name="patientId" class="form-select" required>
                                    <option value="" disabled ${empty consultation.patientId ? 'selected' : ''}>-- Select Patient --</option>
                                    <c:forEach var="p" items="${patients}">
                                        <option value="${p.id}" ${consultation.patientId == p.id ? 'selected' : ''}>
                                            ${p.patientUhid} - ${p.fullName} (${p.gender}, ${p.age} yrs)
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Select Doctor -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Attending Doctor <span class="text-danger">*</span></label>
                                <select name="doctorId" id="doctorSelect" class="form-select" required onchange="updateDoctorFee()">
                                    <option value="" disabled selected>-- Select Doctor --</option>
                                    <c:forEach var="d" items="${doctors}">
                                        <option value="${d.id}" data-fee="${d.consultationFee}">
                                            ${d.name} (${d.specialization} - ₹${d.consultationFee})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Consultation Fee -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Consultation Fee (₹) <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text">₹</span>
                                    <input type="number" step="0.01" name="consultationFee" id="feeInput"
                                           class="form-control" value="500.00" required>
                                </div>
                                <div class="form-text">Auto-populated based on doctor specialization fee.</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Consultation Status</label>
                                <select name="status" class="form-select">
                                    <option value="COMPLETED" selected>COMPLETED</option>
                                    <option value="FOLLOW_UP_REQUIRED">FOLLOW UP REQUIRED</option>
                                </select>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold">Chief Symptoms / Patient Complaints <span class="text-danger">*</span></label>
                                <textarea name="symptoms" class="form-control" rows="2"
                                          placeholder="e.g. Fever for 3 days, dry cough, severe headache..." required></textarea>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold">Clinical Diagnosis <span class="text-danger">*</span></label>
                                <textarea name="diagnosis" class="form-control" rows="2"
                                          placeholder="e.g. Acute Upper Respiratory Tract Infection" required></textarea>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold">Prescription & Medication Advice <span class="text-danger">*</span></label>
                                <textarea name="prescription" class="form-control" rows="3"
                                          placeholder="e.g. Tab Azithromycin 500mg OD x 3 days, Tab Paracetamol 650mg SOS" required></textarea>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold">Internal Doctor Notes / Diet / Restrictions</label>
                                <textarea name="notes" class="form-control" rows="2"
                                          placeholder="Advised complete bed rest and steam inhalation..."></textarea>
                            </div>
                        </div>

                        <hr class="my-4">

                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/consultations" class="btn btn-light px-4">Cancel</a>
                            <button type="submit" class="btn btn-primary px-4">
                                <i class="fa-solid fa-floppy-disk me-1"></i> Save Consultation Record
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function updateDoctorFee() {
    var select = document.getElementById("doctorSelect");
    var selectedOption = select.options[select.selectedIndex];
    var fee = selectedOption.getAttribute("data-fee");
    if (fee) {
        document.getElementById("feeInput").value = fee;
    }
}
</script>

<jsp:include page="common/footer.jsp" />
