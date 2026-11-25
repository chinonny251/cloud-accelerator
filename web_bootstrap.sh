#!/bin/bash
# 1. Update system package index
apt-get update -y

# 2. Install Nginx
apt-get install nginx -y

# 3. Start and enable Nginx service
systemctl start nginx
systemctl enable nginx

# 4. Generate custom cloud portfolio landing page
cat << 'HTML' > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cloud Portfolio | Chinonny</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #0f172a; color: #f8fafc; text-align: center; padding: 50px; margin: 0; }
        .container { background: #1e293b; padding: 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.3); display: inline-block; max-width: 600px; margin-top: 50px; }
        h1 { color: #38bdf8; margin-bottom: 10px; }
        p { color: #94a3b8; font-size: 1.1em; line-height: 1.6; }
        .badge { background: #0284c7; color: white; padding: 6px 12px; border-radius: 20px; font-size: 0.85em; font-weight: bold; text-transform: uppercase; letter-spacing: 1px; display: inline-block; margin-top: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Cloud Architecture Portfolio</h1>
        <p>Welcome to my automated AWS cloud infrastructure deployment!</p>
        <p>This instance was launched within a custom public subnet and provisioned seamlessly using **Terraform User Data** bootstrapping on boot.</p>
        <span class="badge">Week 5, Day 2 Complete</span>
    </div>
</body>
</html>
HTML

# 5. Restart Nginx to apply changes
systemctl restart nginx
