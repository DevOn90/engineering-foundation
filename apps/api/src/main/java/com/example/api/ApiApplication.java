package com.example.api;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import com.example.api.model.User;
import com.example.api.repository.UserRepository;

@SpringBootApplication
public class ApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(ApiApplication.class, args);
	}

	@Bean
	CommandLineRunner initDatabase(UserRepository userRepository) {
		return args -> {
			userRepository.save(new User("Alice"));
			userRepository.save(new User("Bob"));
		};
	}

}
