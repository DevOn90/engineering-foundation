package com.example.api.services.user.contract;

import java.util.List;

import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

import com.example.api.model.User;
import com.example.api.services.user.UserService;

@Service
@Profile("contract")
public class ContractUserService implements UserService {

    @Override
    public List<User> getAllUsers() {
        return List.of();
    }
}

