
-- 1. Find all active partnerships involving a specific company user
SELECT DISTINCT p.id, p.name
FROM Partnership p
JOIN PartnershipUser pu ON p.id = pu.partnership_id
JOIN "User" u ON pu.user_id = u.id
WHERE u.id = "UserID";

-- 2. List all company users with their roles
SELECT c.name AS company_name, u.name AS user_name, u.email, u.role
FROM "User" u
JOIN Company c ON u.company_id = c.id
ORDER BY c.name, u.name;

-- 3. List all users associated with a specific partnership, including their roles
SELECT p.name AS partnership_name, u.name AS user_name, u.email, pu.role AS partnership_role
FROM PartnershipUser pu
JOIN Partnership p ON pu.partnership_id = p.id
JOIN "User" u ON pu.user_id = u.id
WHERE p.id = "PartnershipId";

-- 4. Get the total revenue generated by the specific partnership for a company
SELECT p.name AS partnership_name, c.name AS company_name, SUM(o.total_amount) AS total_revenue
FROM Partnership p
JOIN PartnershipCompany pc ON p.id = pc.partnership_id
JOIN Company c ON pc.company_id = c.id
JOIN Campaign cam ON p.id = cam.partnership_id
JOIN Lead l ON cam.id = l.campaign_id
JOIN Account a ON l.id = a.lead_id
JOIN Opportunity o ON a.id = o.account_id
WHERE p.id = "Partnership Id" AND c.id = "companyId"
GROUP BY p.name, c.name;