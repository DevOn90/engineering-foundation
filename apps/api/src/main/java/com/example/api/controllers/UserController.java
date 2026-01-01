package com.example.api.controllers;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.api.model.User;
import com.example.api.repository.UserRepository;

@RestController
public class UserController {

    private final UserRepository userRepository;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("api/users")
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
    
}
