import { prisma } from "@/lib/prisma";
import { ProductCard } from "@/components/ProductCard";

/**
 * Fetches the latest 12 featured products from the database.
 * This runs as a React Server Component — no client-side JS shipped.
 */
async function getFeaturedProducts() {
  const products = await prisma.product.findMany({
    where: { featured: true },
    orderBy: { createdAt: "desc" },
    take: 12,
    include: {
      category: {
        select: { name: true, slug: true },
      },
    },
  });
  return products;
}

/**
 * Home page for the Acme Storefront.
 * Displays a hero section and a grid of featured products.
 */
export default async function HomePage() {
  const products = await getFeaturedProducts();

  return (
    <div className="mx-auto max-w-7xl px-6 py-12">
      {/* Hero Section */}
      <section className="mb-16 text-center">
        <h1 className="text-5xl font-bold tracking-tight text-gray-900">
          Curated for Modern Living
        </h1>
        <p className="mt-4 text-lg text-gray-600">
          Discover premium products that blend form and function.
        </p>
        {/* FIXME: Hero CTA button should link to /products with active filters */}
        <a
          href="/products"
          className="mt-8 inline-block rounded-full bg-black px-8 py-3 text-sm font-medium text-white hover:bg-gray-800"
        >
          Shop Now
        </a>
      </section>

      {/* Featured Products Grid */}
      <section>
        <h2 className="mb-8 text-2xl font-semibold">Featured Products</h2>
        {products.length === 0 ? (
          <p className="text-gray-500">No featured products found.</p>
        ) : (
          <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
            {products.map((product) => (
              <ProductCard key={product.id} product={product} />
            ))}
          </div>
        )}
      </section>
    </div>
  );
}
