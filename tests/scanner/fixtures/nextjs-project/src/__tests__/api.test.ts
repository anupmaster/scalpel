import { describe, it, expect, vi, beforeEach } from "vitest";

// Mock prisma client
vi.mock("@/lib/prisma", () => ({
  prisma: {
    product: {
      findMany: vi.fn(),
      count: vi.fn(),
    },
  },
}));

import { GET } from "@/app/api/route";
import { prisma } from "@/lib/prisma";
import { NextRequest } from "next/server";

const mockProducts = [
  {
    id: "clx1abc00",
    name: "Ergonomic Desk Lamp",
    slug: "ergonomic-desk-lamp",
    price: 79.99,
    stock: 42,
    featured: true,
    category: { name: "Lighting", slug: "lighting" },
  },
  {
    id: "clx1abc01",
    name: "Minimalist Wall Clock",
    slug: "minimalist-wall-clock",
    price: 45.0,
    stock: 18,
    featured: true,
    category: { name: "Decor", slug: "decor" },
  },
];

function createRequest(url: string): NextRequest {
  return new NextRequest(new URL(url, "http://localhost:3000"));
}

describe("GET /api/products", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("returns paginated products", async () => {
    vi.mocked(prisma.product.findMany).mockResolvedValue(mockProducts as any);
    vi.mocked(prisma.product.count).mockResolvedValue(2);

    const response = await GET(createRequest("/api/products"));
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body.data).toHaveLength(2);
    expect(body.pagination.total).toBe(2);
    expect(body.pagination.page).toBe(1);
  });

  it("filters by category", async () => {
    vi.mocked(prisma.product.findMany).mockResolvedValue([mockProducts[0]] as any);
    vi.mocked(prisma.product.count).mockResolvedValue(1);

    const response = await GET(createRequest("/api/products?category=lighting"));
    const body = await response.json();

    expect(body.data).toHaveLength(1);
    expect(prisma.product.findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        where: expect.objectContaining({
          category: { slug: "lighting" },
        }),
      })
    );
  });

  it("returns 400 for invalid page number", async () => {
    const response = await GET(createRequest("/api/products?page=-1"));
    expect(response.status).toBe(400);
  });

  it("respects limit parameter", async () => {
    vi.mocked(prisma.product.findMany).mockResolvedValue([]);
    vi.mocked(prisma.product.count).mockResolvedValue(0);

    await GET(createRequest("/api/products?limit=5"));

    expect(prisma.product.findMany).toHaveBeenCalledWith(
      expect.objectContaining({ take: 5 })
    );
  });
});
