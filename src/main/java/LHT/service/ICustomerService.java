package LHT.service;

import LHT.model.Customer;
import LHT.model.User;

public interface ICustomerService {
	public Customer findCustomerByUserId(Long userId);

}
