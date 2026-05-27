package LHT.dao;

import java.util.List;

import LHT.dto.OrderDetailDTO;

public interface IOrderDetailDAO {
	 public List<OrderDetailDTO> getOrderDetailByOrderId(long orderId);
}
