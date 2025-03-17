<%@ page import="javax.servlet.http.HttpSession" %>
    HttpSession session1 = request.getSession(false);
    String role = (String) session1.getAttribute("role");

    if (session1 == null || session1.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="mb-3">
        <a href="ExportCSVServlet" class="btn btn-primary">Export CSV</a>
        <a href="ExportPDFServlet" class="btn btn-danger">Export PDF</a>
    </div>
    
    <div class="text-end">
        <a href="LogoutServlet" class="btn btn-danger">Logout</a>
    </div>
    <div class="container mt-4">
        <h2 class="text-center">Inventory Management System</h2>
        <h3>Transfer Stock</h3>
        <form action="TransferStockServlet" method="post">
            <select name="productId" class="form-control">
                <option value="1">Product 1</option>
                <option value="2">Product 2</option>
            </select>
            <select name="fromWarehouse" class="form-control">
                <option value="1">Main Warehouse</option>
                <option value="2">Backup Warehouse</option>
            </select>
            <select name="toWarehouse" class="form-control">
                <option value="1">Main Warehouse</option>
                <option value="2">Backup Warehouse</option>
            </select>
            <input type="number" name="quantity" class="form-control" placeholder="Quantity" required>
            <button type="submit" class="btn btn-primary">Transfer</button>
        </form>
        
        <!-- Form to Add/Update Products -->
        <form action="InventoryServlet" method="post" class="mb-4">
            <input type="hidden" name="id" id="productId">
            <div class="mb-3">
                <label class="form-label">Product Name</label>
                <input type="text" name="name" id="name" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea name="description" id="description" class="form-control"></textarea>
            </div>
            <div class="mb-3">
                <label class="form-label">Quantity</label>
                <input type="number" name="quantity" id="quantity" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Price</label>
                <input type="text" name="price" id="price" class="form-control" required>
            </div>
            <button type="submit" name="action" value="add" class="btn btn-success">Add Product</button>
            <button type="submit" name="action" value="update" class="btn btn-primary">Update Product</button>
        </form>

        <!-- Table to Display Products -->
        <table class="table table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%<% if ("admin".equals(role)) { %>
                    <!-- Admin-Only Buttons -->
                    <button type="submit" class="btn btn-success">Save Product</button>
                <% } %>
                
                    Connection conn = DatabaseConnection.getConnection();
                    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products");
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("description") %></td>
                    <td><%= rs.getInt("quantity") %></td>
                    <td>$<%= rs.getDouble("price") %></td>
                    <td>
                        <form action="InventoryServlet" method="post" class="d-inline">
                            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                            <button type="submit" name="action" value="delete" class="btn btn-danger btn-sm">Delete</button>
                            <form id="productForm" class="mb-4">
                                <input type="hidden" name="id" id="productId">
                                <div class="mb-3">
                                    <label class="form-label">Product Name</label>
                                    <input type="text" name="name" id="name" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <textarea name="description" id="description" class="form-control"></textarea>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Quantity</label>
                                    <input type="number" name="quantity" id="quantity" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Price</label>
                                    <input type="text" name="price" id="price" class="form-control" required>
                                </div>
                                <button type="submit" class="btn btn-success">Save Product</button>
                            </form>
                            
                        </form>

                        <button class="btn btn-warning btn-sm" onclick="editProduct ('<%= rs.getInt("id") %>', '<%= rs.getString("name") %>', '<%= rs.getString("description") %>', '<%= rs.getInt("quantity") %>', '<%= rs.getDouble("price") %>')">Edit</button>
                    </td>
                </tr>
            

    <tbody id="productTable">
        <!-- Products will be loaded dynamically via AJAX -->
    </tbody>
    <table class="table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Product</th>
                <th>Warehouse</th>
                <th>Quantity</th>
            </tr>
        </thead>
        <tbody id="inventoryTable">
            <!-- Data will be loaded dynamically -->
        </tbody>
    </table>
    
        </table>
    </div>
    
    
    <script>
        <script>
$(document).ready(function () {
    function loadWarehouseStock() {
        $.ajax({
            url: "GetWarehouseStockServlet",
            type: "GET",
            success: function (data) {
                $("#inventoryTable").html(data);
            }
        });
    }

    loadWarehouseStock();
})
</script>

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<canvas id="salesChart"></canvas>

<script>
$(document).ready(function () {
    $.ajax({
        url: "SalesReportServlet",
        type: "GET",
        success: function (data) {
            let products = [], sales = [];
            JSON.parse(data).forEach(item => {
                products.push(item.product);
                sales.push(item.sales);
            });

            new Chart(document.getElementById("salesChart"), {
                type: "bar",
                data: {
                    labels: products,
                    datasets: [{
                        label: "Total Sales",
                        data: sales,
                        backgroundColor: "blue"
                    }]
                }
            });
        }
    });
});
</script>

        ,$(document).ready(function () {
        
    function loadLowStockAlerts() {
        $.ajax({
            url: "GetProductsServlet",
            type: "GET",
            success: function (data) {
                $("#productTable").html(data);
                if ($(".table-danger").length > 0) {
                    alert("Warning: Some products are low on stock!");
                }
            }
        });
    }

    loadLowStockAlerts();
        function editProduct(id, name, description, quantity, price) {
            document.getElementById('productId').value = id;
            document.getElementById('name').value = name;
            document.getElementById('description').value = description;
            document.getElementById('quantity').value = quantity;
            document.getElementById('price').value = price;
        }
    </script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function () {
    // Submit Form via AJAX
    $("#productForm").on("submit", function (e) {
        e.preventDefault();

        $.ajax({
            url: "InventoryServlet",
            type: "POST",
            data: $(this).serialize() + "&action=add",
            success: function (response) {
                $("#productForm")[0].reset(); // Reset form
                loadProducts(); // Refresh product list
            }
        });
    });

    // Load Products Without Refresh
    function loadProducts() {
        $.ajax({
            url: "GetProductsServlet",
            type: "GET",
            success: function (data) {
                $("#productTable").html(data);
            }
        });
    }

    // Delete Product via AJAX
    $(document).on("click", ".delete-btn", function () {
        let productId = $(this).data("id");
        $.ajax({
            url: "InventoryServlet",
            type: "POST",
            data: { id: productId, action: "delete" },
            success: function () {
                loadProducts(); // Refresh product list
            }
        });
    });

    loadProducts(); // Load products when the page loads
});
</script>

</body>
</html>
}