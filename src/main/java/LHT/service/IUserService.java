package LHT.service;

import LHT.model.User;

public interface IUserService {
	 public User login(String email, String password) ;
	 public boolean register(User user);
}
