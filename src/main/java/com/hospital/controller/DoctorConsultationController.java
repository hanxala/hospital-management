package com.hospital.controller;

import com.hospital.model.Consultation;
import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import com.hospital.service.ConsultationService;
import com.hospital.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/consultations")
public class DoctorConsultationController {

    private final ConsultationService consultationService;
    private final PatientService patientService;

    @Autowired
    public DoctorConsultationController(ConsultationService consultationService, PatientService patientService) {
        this.consultationService = consultationService;
        this.patientService = patientService;
    }

    @GetMapping
    public String listConsultations(Model model) {
        List<Consultation> list = consultationService.getAllConsultations();
        model.addAttribute("consultations", list);
        return "consultation-list";
    }

    @GetMapping("/new")
    public String showConsultationForm(@RequestParam(value = "patientId", required = false) Long patientId, Model model) {
        Consultation consultation = new Consultation();
        if (patientId != null) {
            consultation.setPatientId(patientId);
            Patient p = patientService.getPatientById(patientId);
            if (p != null) {
                consultation.setPatientName(p.getFullName());
                consultation.setPatientUhid(p.getPatientUhid());
            }
        }

        List<Patient> patients = patientService.getAllPatients();
        List<Doctor> doctors = consultationService.getAllDoctors();

        model.addAttribute("consultation", consultation);
        model.addAttribute("patients", patients);
        model.addAttribute("doctors", doctors);
        return "consultation-form";
    }

    @PostMapping("/save")
    public String saveConsultation(@ModelAttribute("consultation") Consultation consultation,
                                   RedirectAttributes redirectAttributes) {
        consultationService.recordConsultation(consultation);
        redirectAttributes.addFlashAttribute("successMessage", "Doctor consultation recorded successfully.");
        return "redirect:/consultations";
    }
}
