# Acme Storefront

A modern e-commerce storefront built with Next.js 14, React Server Components,
Prisma ORM, and Tailwind CSS. Designed for fast page loads, clean architecture,
and seamless developer experience.

## Tech Stack

- **Framework:** Next.js 14 (App Router)
- **Language:** TypeScript (strict mode)
- **Database:** PostgreSQL via Prisma ORM
- **Styling:** Tailwind CSS 3.4
- **Auth:** NextAuth.js with credentials & OAuth
- **Validation:** Zod
- **State Management:** TanStack React Query
- **Testing:** Vitest + Testing Library
- **CI/CD:** GitHub Actions

## Getting Started

### Prerequisites

- Node.js 20+
- PostgreSQL 16+
- npm 10+

### Installation

```bash
git clone https://github.com/acme/storefront.git
cd storefront
npm install
cp .env.example .env
```

Edit `.env` with your database credentials and auth secrets.

### Database Setup

```bash
npx prisma db push
npx prisma db seed
```

### Development

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### Running Tests

```bash
npm test                  # Run all tests
npm run test:coverage     # Run with coverage report
```

## Project Structure

```
src/
  app/           # Next.js App Router pages and layouts
    api/         # API routes
  components/    # Reusable UI components
  lib/           # Shared utilities and configs
  __tests__/     # Test files
prisma/
  schema.prisma  # Database schema
  seed.ts        # Seed data script
```

## Deployment

The application deploys automatically to Vercel on push to `main`.
Preview deployments are created for all pull requests.

## Contributing

1. Create a feature branch from `main`
2. Make your changes with tests
3. Open a PR targeting `main`
4. Wait for CI to pass and get a review

## License

Proprietary - Acme Inc.
