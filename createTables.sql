
/*This files creates 13 tables in total. This tables are the ones whose schemas are given in part2. We tried to enforce constraints by using not null and unique in tables of relationships.
We generally used on delete cascade because we think that we need to delete rows in relationship tables if any part of the relation is deleted from the database. At the end of the file, we create a trigger to
enforce that there shouldnt be more than 5 row in Database_Manager table. We have learned it from : https://stackoverflow.com/questions/18736775/test-for-countx-inside-sqlite-trigger 
*/

CREATE TABLE Side_effects
( umls_cui VARCHAR(100),
side_effect_name VARCHAR(100),
PRIMARY KEY (umls_cui),
UNIQUE(umls_cui)
);


CREATE TABLE SIDER
( umls_cui VARCHAR(100),
drugbank_id VARCHAR(100) not null,
PRIMARY KEY (umls_cui, drugbank_id),
FOREIGN KEY (umls_cui) REFERENCES Side_effects
ON DELETE CASCADE
FOREIGN KEY (drugbank_id) REFERENCES Drug
ON DELETE CASCADE
);


CREATE TABLE Drug
( drugbank_id VARCHAR(100) , 
description TEXT, 
name TEXT , 
chemical_notation TEXT,
PRIMARY KEY (drugbank_id),
UNIQUE(drugbank_id)
);

CREATE TABLE DrugOf
( reaction_id  INTEGER not null,
drugbank_id VARCHAR(100) not null,
PRIMARY KEY (reaction_id, drugbank_id),
FOREIGN KEY (reaction_id) REFERENCES Reaction
ON DELETE CASCADE
FOREIGN KEY (drugbank_id) REFERENCES Drug
ON DELETE CASCADE
unique(reaction_id)
);

CREATE TABLE Drug_interactions
( drugbank_id1  INTEGER,
drugbank_id2 INTEGER,
PRIMARY KEY (drugbank_id1, drugbank_id2),
FOREIGN KEY (drugbank_id1) REFERENCES Drug (drugbank_id)
ON DELETE CASCADE
FOREIGN KEY (drugbank_id2) REFERENCES Drug (drugbank_id)
ON DELETE CASCADE
);

CREATE TABLE Reaction
( reaction_id INTEGER , 
affinity_nM REAL, 
measure VARCHAR(100) , 
PRIMARY KEY (reaction_id),
UNIQUE(reaction_id)
);

CREATE TABLE ProteinOf
( reaction_id  INTEGER not null,
uniprot_id VARCHAR(100) not null,
PRIMARY KEY (reaction_id, uniprot_id),
FOREIGN KEY (reaction_id) REFERENCES Reaction
ON DELETE CASCADE
FOREIGN KEY (uniprot_id) REFERENCES Protein
ON DELETE CASCADE
unique(reaction_id)
);

CREATE TABLE ArticleOf
( reaction_id  INTEGER not null, 
Doi VARCHAR(100),
PRIMARY KEY (reaction_id, Doi),
FOREIGN KEY (reaction_id) REFERENCES Reaction
ON DELETE CASCADE
FOREIGN KEY (Doi) REFERENCES Protein
ON DELETE CASCADE
);

CREATE TABLE Protein
( uniprot_id VARCHAR(100) , 
name VARCHAR(100), 
sequence TEXT , 
PRIMARY KEY (uniprot_id),
UNIQUE(uniprot_id)
);

CREATE TABLE Article
( Doi VARCHAR(100) , 
PRIMARY KEY (Doi)
);

CREATE TABLE User
( Username VARCHAR(100) , 
Institution VARCHAR(100), 
Password VARCHAR(100) , 
chemical_notation TEXT,
PRIMARY KEY (Username, Institution)
UNIQUE(Username, Institution)
);

CREATE TABLE First_Author
( Doi  VARCHAR(100) not null,
Username VARCHAR(100) not null,
Institution VARCHAR(100) not null,
PRIMARY KEY (Doi, Username, Institution),
FOREIGN KEY (Doi) REFERENCES Article
ON DELETE CASCADE
FOREIGN KEY (Username, Institution) REFERENCES User
ON DELETE CASCADE
unique(Doi)
);

CREATE TABLE Authors
( Doi  VARCHAR(100),
AuthorName VARCHAR(100),
PRIMARY KEY (Doi, AuthorName),
FOREIGN KEY (Doi) REFERENCES Article
ON DELETE CASCADE
);

CREATE TABLE Database_Manager
( user_name VARCHAR(100) , 
password VARCHAR(100),  
PRIMARY KEY (user_name),
UNIQUE(user_name)
);


CREATE TRIGGER mytrigger
BEFORE INSERT ON Database_Manager
BEGIN
    SELECT CASE WHEN 
        (SELECT COUNT (*) FROM Database_Manager) >=5
    THEN
        RAISE(FAIL, "Max limit exceeded.")
    END;
END;