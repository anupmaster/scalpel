import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { z } from "zod";

const ProductQuerySchema = z.object({
  category: z.string().optional(),
  search: z.string().optional(),
  page: z.coerce.number().min(1).default(1),
  limit: z.coerce.number().min(1).max(50).default(20),
  sort: z.enum(["price_asc", "price_desc", "newest", "popular"]).default("newest"),
});

/**
 * GET /api/products
 * Returns paginated product listings with optional filtering and sorting.
 */
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const params = ProductQuerySchema.parse(Object.fromEntries(searchParams));

    const where: Record<string, unknown> = {};
    if (params.category) {
      where.category = { slug: params.category };
    }
    if (params.search) {
      where.OR = [
        { name: { contains: params.search, mode: "insensitive" } },
        { description: { contains: params.search, mode: "insensitive" } },
      ];
    }

    // TODO: Add redis caching layer for frequently accessed product listings
    const orderBy = getOrderBy(params.sort);
    const skip = (params.page - 1) * params.limit;

    const [products, total] = await Promise.all([
      prisma.product.findMany({
        where,
        orderBy,
        skip,
        take: params.limit,
        include: { category: { select: { name: true, slug: true } } },
      }),
      prisma.product.count({ where }),
    ]);

    return NextResponse.json({
      data: products,
      pagination: {
        page: params.page,
        limit: params.limit,
        total,
        totalPages: Math.ceil(total / params.limit),
      },
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: "Invalid query parameters", details: error.flatten() },
        { status: 400 }
      );
    }
    console.error("Failed to fetch products:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}

function getOrderBy(sort: string) {
  switch (sort) {
    case "price_asc":
      return { price: "asc" as const };
    case "price_desc":
      return { price: "desc" as const };
    case "popular":
      return { orderCount: "desc" as const };
    case "newest":
    default:
      return { createdAt: "desc" as const };
  }
}
