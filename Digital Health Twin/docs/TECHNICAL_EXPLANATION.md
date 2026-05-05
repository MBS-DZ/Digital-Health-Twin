# Technical Explanation

## Chosen Solution

The project uses Flutter for the mobile app and .NET Web API for the backend. The app has three screens: Mood Input, Mood History, and Insights. The backend has three REST endpoints: add mood, get history, and analyze.

This approach is suitable for a 24-hour task because it is clear, testable, and easy to explain. The architecture avoids heavy state management, authentication, database migrations, and background sync so the main requirement stays visible.

## Frontend Alternatives

### Simple StatefulWidget

Useful when the app is small and has limited shared state.

Pros:
- Fast to build.
- Easy to understand.
- No extra architecture dependency.

Cons:
- Can become messy as screens and shared state grow.
- Harder to coordinate caching, auth, and complex refresh behavior.

Why chosen here:
- The app only has three screens and simple request/response flows.

### Provider

Useful for small to medium Flutter apps that need shared state.

Pros:
- Lightweight.
- Common in Flutter projects.
- Easier shared state than passing callbacks.

Cons:
- Still requires careful state organization as features grow.

When to use later:
- If history and insights should refresh automatically after every mood save.

### Riverpod

Useful for scalable Flutter apps with testable state and dependency injection.

Pros:
- Stronger compile-time safety than older Provider patterns.
- Good for async state and API services.
- Easier to test business logic.

Cons:
- More concepts for a small prototype.

When to use later:
- If the app adds authentication, offline cache, settings, and multiple modules.

### Bloc

Useful for larger apps where state transitions need to be explicit.

Pros:
- Very structured.
- Good for complex flows.
- Easy to test state transitions.

Cons:
- More boilerplate.
- Slower to build for a small technical task.

When to use later:
- If this becomes a production app with complex user journeys.

### Manual HTTP Service vs Generated API Client

Manual HTTP service is useful when there are only a few endpoints.

Pros:
- Simple and readable.
- No generation step.
- Easy to debug.

Cons:
- More manual JSON mapping.
- Can drift from backend contracts.

Generated API clients are useful when APIs are large or OpenAPI contracts exist.

Pros:
- Type-safe API surface.
- Less manual endpoint code.
- Better contract consistency.

Cons:
- Requires OpenAPI setup and generation workflow.

Why manual service is appropriate here:
- The backend has only three endpoints.

## Backend Alternatives

### .NET Web API

Useful for professional, strongly typed backend APIs.

Pros:
- Strong typing and validation support.
- Clean controller/service structure.
- Good tooling for enterprise teams.
- Easy path to Entity Framework and SQL databases.

Cons:
- Heavier than a small script API.
- Requires .NET SDK setup.

Why chosen here:
- The task preferred .NET, and it presents well in interviews because the structure is clear.

### Python FastAPI

Useful for fast prototypes, AI services, and data-heavy workflows.

Pros:
- Very quick to build.
- Excellent automatic docs.
- Natural fit for AI/ML Python ecosystems.

Cons:
- Runtime typing is less strict than C#.
- Production deployment patterns vary more by team.

When it would be chosen:
- If the task environment did not support .NET or if the next step was Python-based ML.

### Node.js/Express

Useful when the team already uses JavaScript or TypeScript everywhere.

Pros:
- Fast development.
- Huge ecosystem.
- Easy JSON APIs.

Cons:
- Plain Express can become unstructured without conventions.
- Type safety requires TypeScript setup.

When it would be chosen:
- If the frontend and backend team wanted one language stack.

### Firebase or Supabase

Useful for rapid products with managed auth and database.

Pros:
- Built-in auth options.
- Managed database.
- Less backend code.

Cons:
- Less control over backend architecture.
- Vendor-specific rules and pricing.
- Business logic can spread between app and cloud rules/functions.

When it would be chosen:
- If speed and managed infrastructure mattered more than showing backend code.

## Storage Alternatives

### In-Memory List

Useful for demos and technical tasks.

Pros:
- No setup.
- Easy to review.
- Very fast.

Cons:
- Data is lost when the backend restarts.
- Not suitable for multiple servers.

Why chosen here:
- It keeps focus on API design and integration.

### JSON File

Useful for simple local persistence.

Pros:
- Easy to inspect.
- No database server.

Cons:
- Concurrency problems.
- Poor query performance.
- Not ideal for sensitive health data.

### SQLite

Useful for local prototypes or single-server small apps.

Pros:
- Real persistence.
- Simple setup.
- Good for local development.

Cons:
- Limited multi-server scaling.

### PostgreSQL

Useful for production backends.

Pros:
- Reliable relational storage.
- Strong query support.
- Works well with analytics and reporting.

Cons:
- Requires database setup and migrations.

### Firebase Firestore

Useful for real-time mobile apps and managed cloud data.

Pros:
- Offline support.
- Real-time updates.
- Managed scaling.

Cons:
- Query model and pricing need careful design.
- Vendor lock-in.

## Insight Logic Alternatives

### Rule-Based Conditions

Useful when logic must be transparent and quick to build.

Pros:
- Easy to explain.
- Predictable.
- Easy to test.

Cons:
- Not personalized.
- Can miss nuance.

Why chosen here:
- The task explicitly asks for simple rule-based insights.

### Weighted Scoring

Useful when combining several health signals into a single risk score.

Example:
- High stress adds points.
- Low sleep adds points.
- Repeated negative moods add points.
- Notes with concerning keywords add points.

Pros:
- More flexible than simple if-statements.
- Easy to tune thresholds.

Cons:
- Scores can feel arbitrary.
- Needs careful communication to users.

### AI/LLM-Generated Insights

Useful when insights should sound more personalized and natural.

Pros:
- Can summarize patterns in a human-friendly way.
- Can include context from notes.
- Good for coaching-style language.

Cons:
- Needs safety controls.
- Can hallucinate.
- Must avoid medical diagnosis unless properly regulated.
- Privacy and consent become more important.

How to add later:
- Keep the current rule engine as a safety layer.
- Send summarized, minimized data to the AI service.
- Ask the AI to generate supportive language only.
- Add guardrails: no diagnosis, no emergency handling beyond approved crisis messaging.

### Machine Learning Model

Useful when there is enough historical user data to predict trends.

Pros:
- Can personalize predictions.
- Can detect patterns humans may not encode manually.

Cons:
- Requires data, labeling, evaluation, and monitoring.
- Risk of bias and false confidence.
- Harder to explain.

When applicable:
- After collecting enough consented, anonymized longitudinal data.

## Integration Alternatives

### REST API

Useful for standard mobile-backend communication.

Pros:
- Simple.
- Easy to test with curl or Postman.
- Works well for CRUD features.

Cons:
- Multiple endpoints can become chatty in larger apps.

Why chosen here:
- Three simple endpoints are a natural REST fit.

### GraphQL

Useful when clients need flexible queries over complex data.

Pros:
- Client asks for exactly the data needed.
- Good for complex dashboards.

Cons:
- More setup.
- Caching and authorization can be more complex.

### Firebase Direct Integration

Useful for apps that do not need a custom backend initially.

Pros:
- Very fast.
- Real-time and offline features are easier.

Cons:
- Business logic may move into the client or cloud rules.
- Less useful for demonstrating backend API design.

### Offline-First Sync

Useful for health tracking apps where users may enter data without network.

Pros:
- Better user experience.
- Less data loss.

Cons:
- Conflict handling and sync logic add complexity.

When to add later:
- Store entries locally first, then sync when online.

## Interview Talking Points

- I separated UI, API service, DTOs, and backend business logic so each part has one clear responsibility.
- I chose in-memory storage because the assignment is a short prototype and does not require database setup.
- I used REST because the app needs simple create, read, and analyze operations.
- I kept state local with `StatefulWidget` because global state would be extra complexity for three screens.
- I made the API URL configurable because Android emulator, iOS simulator, and physical devices use different host addresses.
- I kept insight logic on the backend so the mobile app only displays results and the rules can change without publishing a new app.
- I avoided real AI for this prototype because health insights need safety, privacy, and guardrails.

## Evaluator Questions and Answers

### Is there another way to build this?

Yes. The mobile app could use Riverpod or Bloc for more structured state management, and the backend could be FastAPI, Node.js, Firebase, or Supabase. For this task, Flutter plus .NET Web API gives a clean full-stack demonstration without too much complexity.

### Why did you choose this backend structure?

The controller handles HTTP concerns, DTOs define request and response shapes, and the service owns storage and insight logic. This is simple but still professional. If the project grows, the service can later use a database repository without changing the Flutter app.

### How would you improve it later?

I would add authentication, persistent storage, backend unit tests, integration tests, offline caching, trend charts, privacy controls, and better clinical disclaimers.

### How would you scale it?

I would replace in-memory storage with PostgreSQL, add user accounts, deploy the API behind a load balancer, add structured logging, and keep stateless API instances so multiple backend servers can run safely.

### How would you store data differently?

For a local prototype I would use SQLite. For production I would use PostgreSQL with tables for users and mood entries. For a managed mobile-first product I might use Firestore or Supabase if real-time sync and managed auth are priorities.

### How would you add real AI later?

I would keep the current rule-based checks as a safety layer and add an AI service that receives only summarized user history. The AI would generate supportive text, not diagnosis. I would add prompt guardrails, content filters, privacy review, and human-approved crisis guidance.

### Why are insights generated on the backend instead of Flutter?

Keeping insight logic on the backend makes it easier to update rules without forcing users to update the app. It also keeps future AI keys, safety logic, and data processing away from the client.

### What are the limitations of the current version?

Data is not persisted after restart, there is no authentication, and insights are basic. That is acceptable for the assignment because the goal is to demonstrate the end-to-end flow clearly.
