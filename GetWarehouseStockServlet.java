@WebServlet("/GetWarehouseStockServlet")
public class GetWarehouseStockServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "SELECT p.id, p.name, w.name AS warehouse, ws.quantity " +
                     "FROM warehouse_stock ws " +
                     "JOIN products p ON ws.product_id = p.id " +
                     "JOIN warehouses w ON ws.warehouse_id = w.id")) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id") + "</td>");
                out.println("<td>" + rs.getString("name") + "</td>");
                out.println("<td>" + rs.getString("warehouse") + "</td>");
                out.println("<td>" + rs.getInt("quantity") + "</td>");
                out.println("</tr>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
