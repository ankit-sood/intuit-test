workspace {
    model {
        # Actors
        creator = person "Creator" "A user of the MyBooks, having access to Create/Update/Delete the Goals & Budgets."
        approver = person "Approver" "A user of the MyBooks, having access to Create/Update/Delete/Approve the Goals & Budgets."
        admin = person "Admin User" "A user of the MyBooks, having access to Create/Update/Delete/Approve the Goals & Budgets. It also has access to add new users."

        # External systems
        emailSystem = softwareSystem "Email System" "The internal Microsoft Exchange System" "internal"
        calendarSystem = softwareSystem "Calendar System" "Calendly" "external"

        # MyBooks System
        MyBooksSystem  = softwareSystem "MyBooks System"{
            webContainer = container "User Web UI" "" "" "frontend"
            adminContainer = container "Admin Web UI" "" "" "frontend"
            
            authApiContainer = container "Authentication API" "Java" {
                signInApiComp = component "SignIn Controller" "Allows users to Sign-in to MyBooks System."
                signUpApiComp = component "Registration Controller" "Allows admins to register new users to MyBooks System."
                authApiComp = component "Authentication"
                authCrudComp = component "CRUD"
            }
            goalsApiContainer = container "Goals API" "Java" {
                goalAuthComp = component "Authentication"
                goalsCrudComp = component "CRUD"
            }
            budgetApiContainer = container "Budgets API" "Java" {
                budgetAuthComp = component "Authentication"
                budgetCrudComp = component "CRUD"
            }
            notificationsApiContainer = container "Notifications API" "Java" {
                notificationsAuthComp = component "Authentication"
                notificationsCrudComp = component "CRUD"
            }
            migrationsApiContainer = container "Migrations API" "Java" {
                migrationsAuthComp = component "Authentication"
                migrationsCrudComp = component "CRUD"
            }
            remindersApiContainer = container "Reminders API" "Java" {
                remindersAuthComp = component "Authentication"
                remindersCrudComp = component "CRUD"
            }
            
            authDbContainer = container "User-Database" "Stores User Registration information, hashed authentication credentials, access logs etc." "PostgreSQL" "database" {
                tags "Database"
            }
            redisContainer = container "Redis Cache" "Redis" "" "cache"
            reminderDbContainer = container "Reminder-Database" "PostgreSQL" "" "database" {
                tags "Database"
            }
            goalsDbContainer = container "Goals-Database" "PostgreSQL" "" "database" {
                tags "Database"
            }
            budgetDbContainer = container "Budgets-Database" "PostgreSQL" "" "database" {
                tags "Database"
            }
            notificationsDbContainer = container "Notifications-Database" "PostgreSQL" "" "database" {
                tags "Database"
            }
            
            notificationsKafkaContainer = container "Notifications-Topic" "Kafka" "" "Messaging Queue"
            
            goalsCDCContainer = container "Goals Change Data Capture" "Java"
            budgetsCDCContainer = container "Budgets Change Data Capture" "Java"
                
        }

        # Relationships (Actors & Systems)
        creator -> webContainer "Create/Update/Delete Goals & Budgets"
        approver -> webContainer "Create/Update/Delete/Approved Goals & Budgets"
        admin -> adminContainer "Manages Goals/Budgets & Creates new Users, "
        notificationsDbContainer -> emailSystem "Sends emails using"
        remindersApiContainer -> calendarSystem "Books the calendar using the meeting invite"
        emailSystem -> approver "Notifications to approve the Goals & Budgets"
        emailSystem -> creator "Notifications of Approval"
        calendarSystem -> approver "Books the calendar using the meeting invite"

        # Relationships (Containers)
        webContainer -> authApiContainer "Uses"
        webContainer -> goalsApiContainer "Uses"
        webContainer -> budgetApiContainer "Uses"
        webContainer -> notificationsApiContainer "Uses"
        webContainer -> migrationsApiContainer "Uses"
        webContainer -> remindersApiContainer "Uses"
        adminContainer -> authApiContainer "Uses"
        adminContainer -> goalsApiContainer "Uses"
        adminContainer -> budgetApiContainer "Uses"
        adminContainer -> notificationsApiContainer "Uses"
        adminContainer -> migrationsApiContainer "Uses"
        adminContainer -> remindersApiContainer "Uses"
        authApiContainer -> authDbContainer "Persists data"
        authApiContainer -> redisContainer "Fetches data and tokens"
        goalsApiContainer -> goalsDbContainer "Uses"
        budgetApiContainer -> budgetDbContainer "Uses"
        notificationsApiContainer -> notificationsDbContainer "Uses"
        goalsCDCContainer -> goalsDbContainer "Listens to"
        budgetsCDCContainer -> budgetDbContainer "Listens to"
        notificationsApiContainer -> notificationsKafkaContainer "Consumes"
        goalsCDCContainer -> notificationsKafkaContainer "Pushes Events"
        budgetsCDCContainer -> notificationsKafkaContainer "Pushes Events"
        remindersApiContainer -> "reminderDbContainer" "Uses"

        # Relationships (Components & Containers)
        authCrudComp -> authDbContainer "Reads from and writes to"
        webContainer -> signInApiComp "Make API calls to [JSON/HTTPS]"
        adminContainer -> signUpApiComp "Make API calls to [JSON/HTTPS]"
        adminContainer -> authApiComp "Authenticates using"
    }
    
    views {
        styles {
            element "Person" {
                background #236CFF
                color white
                shape person
            }
            element "Database" {
                shape cylinder
            }
        }
    }
}