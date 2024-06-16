# game-service

An example service that was generated using the [swift-vapor-api-starter](https://github.com/caseyleehanley/swift-vapor-api-starter) template.

# Data Schema

## Models

### Company
- **id**: UUID, Primary Key
- **name**: String
- **employee_count**: Int

### Platform
- **id**: UUID, Primary Key
- **name**: String
- **release_date**: Date
- **rating**: Double?
- **company_id**: UUID, Foreign Key (references Company.id)

### Game
- **id**: UUID, Primary Key
- **name**: String
- **release_date**: Date
- **rating**: Double?

### Character
- **id**: UUID, Primary Key
- **name**: String
- **age**: Int
- **favorite_color**: String?

### PlatformGamePivot
- **id**: UUID, Primary Key
- **platform_id**: UUID, Foreign Key (references Platform.id)
- **game_id**: UUID, Foreign Key (references Game.id)

### GameCharacterPivot
- **id**: UUID, Primary Key
- **game_id**: UUID, Foreign Key (references Game.id)
- **character_id**: UUID, Foreign Key (references Character.id)

## Relationships

- A **Company** has many **Platforms**
- A **Platform** belongs to a **Company**
- A **Platform** has many **Games** (through **PlatformGamePivot**)
- A **Game** belongs to many **Platforms** (through **PlatformGamePivot**)
- A **Game** has many **Characters** (through **GameCharacterPivot**)
- A **Character** belongs to many **Games** (through **GameCharacterPivot**)
