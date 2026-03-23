import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import { Button } from "@/components/Button";

describe("Button", () => {
  it("renders children correctly", () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole("button")).toHaveTextContent("Click me");
  });

  it("applies the primary variant by default", () => {
    render(<Button>Primary</Button>);
    const button = screen.getByRole("button");
    expect(button.className).toContain("bg-black");
    expect(button.className).toContain("text-white");
  });

  it("applies the secondary variant", () => {
    render(<Button variant="secondary">Secondary</Button>);
    const button = screen.getByRole("button");
    expect(button.className).toContain("bg-gray-100");
  });

  it("applies size classes", () => {
    render(<Button size="lg">Large</Button>);
    const button = screen.getByRole("button");
    expect(button.className).toContain("px-6");
    expect(button.className).toContain("py-3");
  });

  it("handles click events", () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click</Button>);
    fireEvent.click(screen.getByRole("button"));
    expect(handleClick).toHaveBeenCalledOnce();
  });

  it("shows loading state and disables interaction", () => {
    const handleClick = vi.fn();
    render(
      <Button loading onClick={handleClick}>
        Submit
      </Button>
    );
    const button = screen.getByRole("button");
    expect(button).toBeDisabled();
    expect(button).toHaveTextContent("Loading...");
    fireEvent.click(button);
    expect(handleClick).not.toHaveBeenCalled();
  });

  it("supports disabled state", () => {
    render(<Button disabled>Disabled</Button>);
    expect(screen.getByRole("button")).toBeDisabled();
  });

  it("applies fullWidth class", () => {
    render(<Button fullWidth>Full Width</Button>);
    expect(screen.getByRole("button").className).toContain("w-full");
  });

  it("forwards ref to the button element", () => {
    const ref = { current: null as HTMLButtonElement | null };
    render(<Button ref={ref}>Ref Button</Button>);
    expect(ref.current).toBeInstanceOf(HTMLButtonElement);
  });
});
