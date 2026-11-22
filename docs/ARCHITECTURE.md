## Architecture *(planned)*

```
Browser: Next.js (App Router) + TypeScript + Tailwind, Zod, TanStack Query
   │
   ▼
FastAPI: Router → Pydantic → Service → Repository (raw SQL)
   │   JWT + roles · rate limiting · request IDs · exception handlers · structured logs
   ▼
psycopg v3 async pool
   │
   ▼
PostgreSQL
```

## Stack

PostgreSQL · psycopg v3 · Python · FastAPI · Pydantic v2 · JWT · TypeScript · React · Next.js · TanStack Query · Zod · Tailwind CSS · Git/GitHub.