package LHT.dao.impl;

import LHT.dto.OrderDetailDTO;
import LHT.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OrderDetailDAO {

    public List<OrderDetailDTO> getOrderDetailByOrderId(Long orderId) {

        List<OrderDetailDTO> list = new ArrayList<>();

        String sql = """
            SELECT
                oi.product_id,
                p.product_name,
                oi.quantity,
                oi.unit_price,
                (oi.quantity * oi.unit_price) AS total_price,

                o.order_id,
                o.customer_id,
                o.order_date,
                o.total_amount,
                o.status,
                o.payment_method,
                o.recipient_name,
                o.phone_number,
                o.delivery_address

            FROM order_line oi

            JOIN products p
                ON oi.product_id = p.product_id

            JOIN orders o
                ON oi.order_id = o.order_id

            WHERE oi.order_id = ?
        """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setLong(1, orderId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                OrderDetailDTO dto =
                        OrderDetailDTO.fromResultSet(rs);

                list.add(dto);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }
}