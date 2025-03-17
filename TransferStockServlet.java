@WebServlet("/TransferStockServlet")
public class TransferStockServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int fromWarehouse = Integer.parseInt(request.getParameter("fromWarehouse"));
        int toWarehouse = Integer.parseInt(request.getParameter("toWarehouse"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            // Reduce stock from source warehouse
            PreparedStatement reduceStmt = conn.prepareStatement(
                "UPDATE warehouse_stock SET quantity = quantity - ? WHERE product_id = ? AND warehouse_id = ? AND quantity >= ?");
            reduceStmt.setInt(1, quantity);
            reduceStmt.setInt(2, productId);
            reduceStmt.setInt(3, fromWarehouse);
            reduceStmt.setInt(4, quantity);

            int rowsAffected = reduceStmt.executeUpdate();
            if (rowsAffected == 0) {
                conn.rollback();
                response.sendRedirect("inventory.jsp?error=Insufficient stock");
                return;
            }

            // Add stock to destination warehouse
            PreparedStatement addStmt = conn.prepareStatement(
                "INSERT INTO warehouse_stock (product_id, warehouse_id, quantity) VALUES (?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE quantity = quantity + ?");
            addStmt.setInt(1, productId);
            addStmt.setInt(2, toWarehouse);
            addStmt.setInt(3, quantity);
            addStmt.setInt(4, quantity);
            addStmt.executeUpdate();

            conn.commit();
            response.sendRedirect("inventory.jsp?success=Stock transferred successfully");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("inventory.jsp?error=Stock transfer failed");
        }
    }
}
