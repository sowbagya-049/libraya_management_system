CREATE DATABASE freelancer_sys;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    role ENUM('admin', 'freelancer', 'client') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE freelancers (
    freelancer_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    skills TEXT, 
    experience INT,
    portfolio VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    company_name VARCHAR(255),
    contact_info VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    project_name VARCHAR(255) NOT NULL,
    description TEXT,
    required_skills TEXT,
    budget DECIMAL(10, 2),
    deadline DATE,
    status ENUM('open', 'assigned', 'in progress', 'completed') DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE
);

CREATE TABLE project_applications (
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    freelancer_id INT NOT NULL,
    proposal TEXT,
    estimated_time VARCHAR(50),
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'accepted', 'rejected') DEFAULT 'pending',
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (freelancer_id) REFERENCES freelancers(freelancer_id) ON DELETE CASCADE
);

CREATE TABLE project_assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    freelancer_id INT NOT NULL,
    assigned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('in progress', 'completed', 'cancelled') DEFAULT 'in progress',
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (freelancer_id) REFERENCES freelancers(freelancer_id) ON DELETE CASCADE
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    amount DECIMAL(10, 2),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'completed') DEFAULT 'pending',
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (freelancer_id) REFERENCES freelancers(freelancer_id) ON DELETE CASCADE
);

CREATE TABLE messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    message_text TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE CASCADE
);
CREATE TABLE profile_viewers (
    id INT AUTO_INCREMENT,
    viewer_name VARCHAR(255),
    freelancer_name VARCHAR(255),
    PRIMARY KEY (id)
);
CREATE TABLE activity_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    activity_type VARCHAR(255),
    email VARCHAR(25),
    activity_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


describe users;
desc users;
select  * from users;
select * from projects;
INSERT INTO projects (project_id, client_id, project_name, description, required_skills, budget, deadline, status, created_at)
VALUES (2, 1, 'air pollution', 'dfhwhf', 'shbwef', 199, '2024-06-12', 'open', CURRENT_TIMESTAMP);


ALTER TABLE projects 
ADD freelancer_id INT NULL, 
ADD FOREIGN KEY (freelancer_id) REFERENCES freelancers(freelancer_id) ON DELETE CASCADE;
CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    client_id INT NOT NULL,
    freelancer_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (freelancer_id) REFERENCES freelancers(freelancer_id) ON DELETE CASCADE
);
ALTER TABLE freelancers ADD name VARCHAR(255);

SELECT p.project_id, p.project_name, f.freelancer_id, u.username AS freelancer_name,
       c.client_id, c.company_name AS client_name
FROM projects p
LEFT JOIN freelancers f ON p.freelancer_id = f.freelancer_id
LEFT JOIN users u ON f.user_id = u.user_id
LEFT JOIN clients c ON p.client_id = c.client_id
LIMIT 0, 1000;


SELECT c.client_id, c.company_name AS client_name, c.contact_info AS client_email, 
       COUNT(p.project_id) AS project_count, 
       GROUP_CONCAT(u.username SEPARATOR ', ') AS freelancer_names 
FROM clients c 
LEFT JOIN projects p ON c.client_id = p.client_id 
LEFT JOIN freelancers f ON p.freelancer_id = f.freelancer_id 
LEFT JOIN users u ON f.user_id = u.user_id 
GROUP BY c.client_id;
SELECT f.freelancer_id, u.username AS name, u.email, 
       COUNT(p.project_id) AS project_count, 
       GROUP_CONCAT(p.project_name SEPARATOR ', ') AS project_names, 
       GROUP_CONCAT(c.company_name SEPARATOR ', ') AS client_names 
FROM freelancers f 
LEFT JOIN users u ON f.user_id = u.user_id 
LEFT JOIN projects p ON f.freelancer_id = p.freelancer_id 
LEFT JOIN clients c ON p.client_id = c.client_id 
GROUP BY f.freelancer_id;
CREATE TABLE starred_projects (
    starred_project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    client_id INT NOT NULL,
    freelancer_id INT NOT NULL,
    project_name VARCHAR(255) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (freelancer_id) REFERENCES freelancers(freelancer_id) ON DELETE CASCADE
);
select * from starred_projects;
select * from sales ;
UPDATE projects SET freelancer_id = 2 WHERE project_id = 1;
desc projects ;


INSERT INTO projects (
    project_id ,
    client_id,
    project_name,
    description,
    required_skills,
    budget,
    deadline,
    status,
    created_at,
    freelancer_id
) VALUES (
     1,
    8,             -- client_id
    'Website Development',   -- project_name
    'Develop a responsive e-commerce website.',  -- description
    'HTML, CSS, JavaScript, PHP, MySQL',         -- required_skills
    1500.00,         -- budget
    '2024-12-31',    -- deadline
    'open',          -- status
    CURRENT_TIMESTAMP,  -- created_at
    2                -- freelancer_id
);

desc freelancers;
INSERT INTO freelancers (
    freelancer_id,
    user_id,
    skills,
    experience,
    portfolio,
    name
) VALUES (
    2,                         -- freelancer_id
    2,                      -- user_id (example ID for the user)
    'Web Development, PHP, MySQL, JavaScript',  -- skills
    5,                         -- experience (e.g., 5 years)
    'https://portfolio.example.com/freelancer2',  -- portfolio URL
    'Alex Johnson'             -- name

);
INSERT INTO projects (
    client_id,
    project_name,
    description,
    required_skills,
    budget,
    deadline,
    status,
    created_at,
    freelancer_id
) VALUES (
    8,                -- client_id
    'Website Development',   -- project_name
    'Develop a responsive e-commerce website.',  -- description
    'HTML, CSS, JavaScript, PHP, MySQL',         -- required_skills
    1500.00,          -- budget
    '2024-12-31',     -- deadline
    'open',           -- status
    CURRENT_TIMESTAMP, -- created_at
    2                 -- freelancer_id
);

INSERT INTO clients (
    user_id,
    company_name,
    contact_info
) VALUES (
    8,                      -- user_id (example ID that should exist in the users table)
    'Tech Innovations LLC',     -- company_name
    'contact@techinnovations.com'  -- contact_info
);
INSERT INTO projects (
    project_id,
    client_id,
    project_name,
    description,
    required_skills,
    budget,
    deadline,
    status,
    created_at,
    freelancer_id
) VALUES (
    3,               -- New unique project_id
    8,               -- client_id
    'Website Development',   -- project_name
    'Develop a responsive e-commerce website.',  -- description
    'HTML, CSS, JavaScript, PHP, MySQL',         -- required_skills
    1500.00,          -- budget
    '2024-12-31',     -- deadline
    'open',           -- status
    CURRENT_TIMESTAMP, -- created_at
    2                 -- freelancer_id
);
select * from projects ;
select * from sales ;
select * from starred_projects;
alter TABLE starred_projects MODIFY client_id INT NULL;
ALTER TABLE starred_projects MODIFY project_name VARCHAR(255) NULL;
SELECT sp.starred_project_id, sp.project_id, sp.project_name, p.description, p.budget, p.deadline
FROM starred_projects sp 
JOIN projects p ON sp.project_id = p.project_id 
WHERE sp.freelancer_id = 2;  -- Replace '1' with your actual freelancer ID

select * from clients;
select * from users;
desc clients ;
desc users ;
desc freelancers;
select * from freelancers;
desc clients;
select * from clients;



desc starred_projects;

SELECT 
    sp.starred_project_id,
    sp.project_id,
    sp.client_id,
    sp.freelancer_id,
    sp.project_name,
    c.company_name AS client_company
FROM 
    starred_projects sp
JOIN 
    clients c ON sp.client_id = c.client_id
WHERE 
    sp.client_id = 4;  -- Replace '?' with the specific client_id

select * from starred_projects;
CREATE TABLE portfolio (
    portfolio_id INT AUTO_INCREMENT PRIMARY KEY,
    freelancer_id INT,
    project_id int ,
    title VARCHAR(100) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    description TEXT,
    skills VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (freelancer_id) REFERENCES freelancers(freelancer_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);
select * from projects;
desc starred_projects;
desc projects ;
desc freelancers;
ALTER TABLE projects MODIFY client_id INT NULL;
ALTER TABLE projects MODIFY client_id INT DEFAULT 0;

desc projects ;
select * from projects;

desc sales ;
SELECT * FROM SALES ;
DESC starred_projects;
SELECT * FROM starred_projects;

DESC portfolio;
select * from portfolio;