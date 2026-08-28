-- Top countries
SELECT country, COUNT(*) total_leads
FROM leads GROUP BY country ORDER BY total_leads DESC;

-- Technology performance
SELECT technology, COUNT(*) leads, SUM(c.replied) replies
FROM leads l JOIN campaigns c ON l.lead_id=c.lead_id
GROUP BY technology ORDER BY replies DESC;

-- Monthly campaign performance
SELECT DATE_FORMAT(sent_time,'%Y-%m') month,
       COUNT(*) emails_sent,
       SUM(delivery_status='Delivered') delivered,
       SUM(opened) opens,
       SUM(replied) replies
FROM campaigns GROUP BY DATE_FORMAT(sent_time,'%Y-%m')
ORDER BY month;

-- High-priority leads
SELECT lead_id, company_id, country, industry, technology, lead_score
FROM leads WHERE lead_score >= 85 ORDER BY lead_score DESC;

-- Industry reply rate
SELECT l.industry,
       COUNT(*) emails_sent,
       SUM(c.replied) replies,
       ROUND(100*SUM(c.replied)/COUNT(*),2) reply_rate_pct
FROM leads l JOIN campaigns c ON l.lead_id=c.lead_id
GROUP BY l.industry ORDER BY reply_rate_pct DESC;
