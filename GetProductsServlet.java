@WebServlet("/GetProductsServlet")
public class GetProductsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products")) {
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int quantity = rs.getInt("quantity");
                String alertClass = (quantity < 5) ? "table-danger" : ""; // Low stock alert
                
                out.println("<tr class='" + alertClass + "'>");
                out.println("<td>" + rs.getInt("id") + "</td>");
                out.println("<td>" + rs.getString("name") + "</td>");
                out.println("<td>" + rs.getString("description") + "</td>");
                out.println("<td>" + quantity + "</td>");
                out.println("<td>$" + rs.getDouble("price") + "</td>");
                out.println("<td>");
                out.println("<button class='btn btn-danger btn-sm delete-btn' data-id='" + rs.getInt("id") + "'>Delete</button>");
                out.println("</td>");
                out.println("</tr>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
