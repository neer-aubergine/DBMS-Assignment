
    

CREATE TYPE user_role AS ENUM ('Admin', 'User', 'Ops-Manager');
CREATE TYPE partnership_role AS ENUM ('Owner', 'Collaborator');


CREATE TABLE Company (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    domain VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE "User" (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES Company(id),
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    role user_role NOT NULL,
    CONSTRAINT valid_email_domain CHECK (email LIKE '%@' || (SELECT domain FROM Company WHERE id = company_id))
);

CREATE TABLE Partnership (
    id SERIAL PRIMARY KEY,
    lead_company_id INTEGER NOT NULL REFERENCES Company(id),
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE PartnershipCompany (
    partnership_id INTEGER REFERENCES Partnership(id),
    company_id INTEGER REFERENCES Company(id),
    PRIMARY KEY (partnership_id, company_id)
);

CREATE TABLE PartnershipUser (
    id SERIAL PRIMARY KEY,
    partnership_id INTEGER NOT NULL REFERENCES Partnership(id),
    user_id INTEGER NOT NULL REFERENCES "User"(id),
    role partnership_role NOT NULL,
    UNIQUE (partnership_id, user_id)
);

CREATE TABLE Campaign (
    id SERIAL PRIMARY KEY,
    partnership_id INTEGER NOT NULL REFERENCES Partnership(id),
    name VARCHAR(255) NOT NULL,
    start_date DATE,
    end_date DATE,
    CHECK (start_date <= end_date)
);

CREATE TABLE Lead (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL REFERENCES Campaign(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    email VARCHAR(255) NOT NULL
);

CREATE TABLE Account (
    id SERIAL PRIMARY KEY,
    lead_id INTEGER REFERENCES Lead(id),
    name VARCHAR(255) NOT NULL,
    website VARCHAR(255)
);

CREATE TABLE Opportunity (
    id SERIAL PRIMARY KEY,
    account_id INTEGER NOT NULL REFERENCES Account(id),
    name VARCHAR(255) NOT NULL,
    total_amount DECIMAL(15, 2) NOT NULL
);

CREATE TABLE Solution (
    id SERIAL PRIMARY KEY,
    partnership_id INTEGER NOT NULL REFERENCES Partnership(id),
    name VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE SolutionCampaign (
    solution_id INTEGER REFERENCES Solution(id),
    campaign_id INTEGER REFERENCES Campaign(id),
    PRIMARY KEY (solution_id, campaign_id)
);

CREATE TABLE SolutionLead (
    solution_id INTEGER REFERENCES Solution(id),
    lead_id INTEGER REFERENCES Lead(id),
    PRIMARY KEY (solution_id, lead_id)
);


