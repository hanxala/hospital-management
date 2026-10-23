package com.hospital.controller;

import com.hospital.model.Consultation;
import com.hospital.model.LabOrder;
import com.hospital.model.Patient;
import com.hospital.service.BillingService;
import com.hospital.service.ConsultationService;
import com.hospital.service.LaboratoryService;
import com.hospital.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/patients")
public class PatientController {

    private final PatientService patientService;
    private final ConsultationService consultationService;
    private final LaboratoryService laboratoryService;
    private final BillingService billingService;

    @Autowired
    public PatientController(PatientService patientService,
                             ConsultationService consultationService,
                             LaboratoryService laboratoryService,
                             BillingService billingService) {
        this.patientService = patientService;
        this.consultationService = consultationService;
        this.laboratoryService = laboratoryService;
        this.billingService = billingService;
    }

    @GetMapping
    public String listPatients(@RequestParam(value = "search", required = false) String search,
                               @RequestParam(value = "success", required = false) String success,
                               Model model) {
        List<Patient> patients = (search != null && !search.trim().isEmpty())
                ? patientService.searchPatients(search)
                : patientService.getAllPatients();

        model.addAttribute("patients", patients);
        model.addAttribute("searchQuery", search);
        model.addAttribute("success", success);
        return "patient-list";
    }

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        Patient patient = new Patient();
        patient.setPatientUhid(patientService.getNextUhid());
        patient.setStatus("ACTIVE");
        model.addAttribute("patient", patient);
        model.addAttribute("isEdit", false);
        return "patient-form";
    }

    @PostMapping("/register")
    public String registerPatient(@ModelAttribute("patient") Patient patient, RedirectAttributes redirectAttributes) {
        Long id = patientService.registerPatient(patient);
        redirectAttributes.addFlashAttribute("successMessage", "Patient registered successfully with UHID: " + patient.getPatientUhid());
        return "redirect:/patients/view/" + id;
    }

    @GetMapping("/view/{id}")
    public String viewPatient(@PathVariable("id") Long id, Model model) {
        Patient patient = patientService.getPatientById(id);
        if (patient == null) {
            return "redirect:/patients";
        }
        List<Consultation> consultations = consultationService.getConsultationsByPatientId(id);
        List<LabOrder> labOrders = laboratoryService.getOrdersByPatientId(id);

        model.addAttribute("patient", patient);
        model.addAttribute("consultations", consultations);
        model.addAttribute("labOrders", labOrders);
        model.addAttribute("bills", billingService.getBillsByPatientId(id));
        return "patient-view";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Long id, Model model) {
        Patient patient = patientService.getPatientById(id);
        if (patient == null) {
            return "redirect:/patients";
        }
        model.addAttribute("patient", patient);
        model.addAttribute("isEdit", true);
        return "patient-form";
    }

    @PostMapping("/edit/{id}")
    public String updatePatient(@PathVariable("id") Long id, @ModelAttribute("patient") Patient patient, RedirectAttributes redirectAttributes) {
        patient.setId(id);
        patientService.updatePatient(patient);
        redirectAttributes.addFlashAttribute("successMessage", "Patient profile updated successfully.");
        return "redirect:/patients/view/" + id;
    }

    @PostMapping("/delete/{id}")
    public String deletePatient(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        patientService.deletePatient(id);
        redirectAttributes.addFlashAttribute("successMessage", "Patient record deleted successfully.");
        return "redirect:/patients";
    }
}
