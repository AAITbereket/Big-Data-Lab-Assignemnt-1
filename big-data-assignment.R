

install.packages("RSQLite")

library(DBI)

connection <- dbConnect(RSQLite::SQLite(), ":memory:")

###### CREATING TABLES
dbSendQuery(connection, "CREATE TABLE users (
                                id integer PRIMARY KEY,
                                email text NOT NULL,
                                password text NOT NULL,
                                age integer)")


dbSendQuery(connection, "CREATE TABLE posts (
                                id integer PRIMARY KEY,
                                title text NOT NULL,
                                description text NOT NULL,
                                user_id integer NOT NULL,
                                FOREIGN KEY (user_id) REFERENCES users(id))")

dbSendQuery(connection, "CREATE TABLE comments (
                                id integer PRIMARY KEY,
                                description text NOT NULL,
                                post_id integer NOT NULL,
                                FOREIGN KEY (post_id) REFERENCES posts(id))")

tables <- dbListTables(connection)
tables
#######

####### INSERTING INTO TABLE USERS
id <- 1:6
email <- c("user1@gmail.com", "user2@gmail.com", "user3@gmail.com", "user4@gmail.com","user5@gmail.com","user6@gmail.com")
password <- rep("pas", 6)
age <- c(32, 5, 38, 20, 88, 12)

df_user <- data.frame(id, email, password, age)

colnames(df_user) <- c('id', 'email', 'password', 'age')

dbWriteTable(connection, "users", df_user, append=T)
users <- dbReadTable(connection, "users")
users
#######

####### READING TABLE USERS
dbReadTable(connection, "users")
#######

####### UPDATING TABLE USERS
dbSendQuery(connection, "UPDATE users set email='email_changed@gmail.com' WHERE id=3")
users <- dbReadTable(connection, "users")
users
######

####### DELETING FROM TABLE USERS
dbSendQuery(connection, "DELETE FROM users WHERE id=6")
dbReadTable(connection, "users")

#######


####### CREATE AGE_GROUP OPERATION ON THE USERS TABLE
age_group <- vector(mode="character", length=length(users$email))

age_group[users$age <= 21] <- "Young"
age_group[users$age <= 40 & users$age > 21] <- "Adult"
age_group[users$age > 40] <- "Old"


users$age_group <- age_group

dbWriteTable(connection, "users", users, overwrite=T)

dbReadTable(connection, "users")

#######

###### HEAD AND TAIL FUNCTIONS
head(users)
tail(users)
summary(users)
######
