workspace {
    model {
        # Actors
        creator = person "Creator" "" "person"
        approver = person "Approver" "" "person"
        admin = person "Admin User" "" "person"

        # External systems
        emailSystem = softwareSystem "Email System" "Mailgun" "external"
        calendarSystem = softwareSystem "Calendar System" "Calendly" "external"

        # MyBooks System
        MyBooksSystem  = softwareSystem "MyBooks System"{
            webContainer = container "User Web UI" "" "" "frontend"
            adminContainer = container "Admin Web UI" "" "" "frontend"
            
            authApiContainer = container "Authentication API" "Java" {
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
            
            authDbContainer = container "User-Database" "PostgreSQL" "" "database"
            redisContainer = container "Redis Cache" "Redis" "" "cache"
            reminderDbContainer = container "Reminder-Database" "PostgreSQL" "" "database"
            goalsDbContainer = container "Goals-Database" "PostgreSQL" "" "database"
            budgetDbContainer = container "Budgets-Database" "PostgreSQL" "" "database"
            notificationsDbContainer = container "Notifications-Database" "PostgreSQL" "" "database"
            
            notificationsKafkaContainer = container "Notifications-Topic" "Kafka" "" "Messaging Queue"
            
            goalsCDCContainer = container "Goals Change Data Capture" "Java"
            budgetsCDCContainer = container "Budgets Change Data Capture" "Java"
                
        }

        # Relationships (Actors & Systems)
        creator -> webContainer "Manage Goals/Budgets"
        approver -> webContainer "Manages tasks"
        admin -> adminContainer "Manages users"
        notificationsDbContainer -> emailSystem "Sends emails"
        remindersApiContainer -> calendarSystem "Creates tasks in Calendar"

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
        webContainer -> authApiComp "Authenticates using"
        adminContainer -> authApiComp "Authenticates using"
    }
}