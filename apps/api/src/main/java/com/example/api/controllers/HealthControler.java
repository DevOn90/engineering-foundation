package com.example.api.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthControler {

    @GetMapping("/api/health")
    public String health() {
        return "{\"status\":\"UP\"}";
    }
}
