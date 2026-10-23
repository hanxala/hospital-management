<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${isEdit ? 'Edit Patient' : 'Register New Patient'} - LifeCare Hospital" />
<c:set var="activePage" value="patients" />
<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<div class="content-wrapper">
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-lg-9">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3 class="fw-bold text-dark mb-1">
                            <i class="fa-solid fa-user-plus text-primary me-2"></i>
                            ${isEdit ? 'Update Patient Profile' : 'New Patient Registration'}
                        </h3>
                        <p class="text-muted mb-0">Fill in patient demographics and clinical history for hospital admission and records.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/patients" class="btn btn-outline-secondary">
                        <i class="fa-solid fa-arrow-left me-1"></i> Back to Patients
                    </a>
                </div>

                <div class="card card-custom p-4">
                    <form action="${isEdit ? pageContext.request.contextPath.concat('/patients/edit/').concat(patient.id) : pageContext.request.contextPath.concat('/patients/register')}"
                          method="post">

                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Patient UHID <span class="text-danger">*</span></label>
                                <input type="text" name="patientUhid" class="form-control bg-light"
                                       value="${patient.patientUhid}" readonly required>
                                <div class="form-text">Auto-generated Unique Health ID.</div>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">First Name <span class="text-danger">*</span></label>
                                <input type="text" name="firstName" class="form-control"
                                       value="${patient.firstName}" placeholder="e.g. Rahul" required>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Last Name <span class="text-danger">*</span></label>
                                <input type="text" name="lastName" class="form-control"
                                       value="${patient.lastName}" placeholder="e.g. Sharma" required>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label fw-semibold">Age (Years) <span class="text-danger">*</span></label>
                                <input type="number" name="age" class="form-control" min="0" max="130"
                                       value="${patient.age}" placeholder="Age" required>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label fw-semibold">Gender <span class="text-danger">*</span></label>
                                <select name="gender" class="form-select" required>
                                    <option value="" disabled ${empty patient.gender ? 'selected' : ''}>Select Gender</option>
                                    <option value="Male" ${patient.gender == 'Male' ? 'selected' : ''}>Male</option>
                                    <option value="Female" ${patient.gender == 'Female' ? 'selected' : ''}>Female</option>
                                    <option value="Other" ${patient.gender == 'Other' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label fw-semibold">Blood Group</label>
                                <select name="bloodGroup" class="form-select">
                                    <option value="Unknown" ${empty patient.bloodGroup || patient.bloodGroup == 'Unknown' ? 'selected' : ''}>Unknown</option>
                                    <option value="A+" ${patient.bloodGroup == 'A+' ? 'selected' : ''}>A+</option>
                                    <option value="A-" ${patient.bloodGroup == 'A-' ? 'selected' : ''}>A-</option>
                                    <option value="B+" ${patient.bloodGroup == 'B+' ? 'selected' : ''}>B+</option>
                                    <option value="B-" ${patient.bloodGroup == 'B-' ? 'selected' : ''}>B-</option>
                                    <option value="O+" ${patient.bloodGroup == 'O+' ? 'selected' : ''}>O+</option>
                                    <option value="O-" ${patient.bloodGroup == 'O-' ? 'selected' : ''}>O-</option>
                                    <option value="AB+" ${patient.bloodGroup == 'AB+' ? 'selected' : ''}>AB+</option>
                                    <option value="AB-" ${patient.bloodGroup == 'AB-' ? 'selected' : ''}>AB-</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label fw-semibold">Status</label>
                                <select name="status" class="form-select">
                                    <option value="ACTIVE" ${patient.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                    <option value="DISCHARGED" ${patient.status == 'DISCHARGED' ? 'selected' : ''}>DISCHARGED</option>
                                    <option value="INACTIVE" ${patient.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Contact Phone <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-phone text-muted"></i></span>
                                    <input type="text" name="phone" class="form-control"
                                           value="${patient.phone}" placeholder="+91 9876543210" required>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Email Address</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-envelope text-muted"></i></span>
                                    <input type="email" name="email" class="form-control"
                                           value="${patient.email}" placeholder="patient@example.com">
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Residential Address</label>
                                <input type="text" name="address" class="form-control"
                                       value="${patient.address}" placeholder="Flat, Street, City, State, PIN">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Emergency Contact Person & Phone</label>
                                <input type="text" name="emergencyContact" class="form-control"
                                       value="${patient.emergencyContact}" placeholder="e.g. Brother: Suresh (+91 9822001122)">
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold">Known Medical History / Allergies / Notes</label>
                                <textarea name="medicalHistory" class="form-control" rows="3"
                                          placeholder="Diabetes, Hypertension, Drug allergies (Penicillin), previous surgeries...">${patient.medicalHistory}</textarea>
                            </div>
                        </div>

                        <hr class="my-4">

                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/patients" class="btn btn-light px-4">Cancel</a>
                            <button type="submit" class="btn btn-primary px-4">
                                <i class="fa-solid fa-floppy-disk me-1"></i>
                                ${isEdit ? 'Save Changes' : 'Complete Registration'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />
