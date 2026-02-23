type DeepNode = {
  id: string;
  metadata: {
    author: { name: string; contact: { email: string; phone: number } };
    tags: string[];
    settings: { mode: 'auto' | 'manual'; retry: boolean; delay: number };
  };
  children?: DeepNode[]; // Recursion makes the error grow exponentially
};

// A deeply nested constant that is missing one leaf property or has a type mismatch
const systemState: DeepNode = {
  id: "001",
  metadata: {
    author: { name: "Dev", contact: { email: "test@test.com", phone: 12345 } },
    tags: ["prod"],
    settings: { mode: 'auto', retry: true, delay: "100ms" as any } 
  },
  children: [
    {
      id: "002",
      metadata: {
        author: { name: "Ops", contact: { email: "ops@test.com", phone: 999 } },
        tags: ["internal"],
        settings: { mode: 'manual', retry: false, delay: 500 }
      },
      // If we create a mismatch here, TS will list all parent properties too
      children: [{ id: "003", metadata: { /* Missing metadata properties */ } } ]
    }
  ]
};

type LargeUnion = 
  | { type: 'A'; data: { x: number; y: number; label: string; visible: boolean } }
  | { type: 'B'; data: { items: string[]; count: number; owner: { id: string } } }
  | { type: 'C'; config: { url: string; method: 'GET' | 'POST'; headers: Record<string, string> } }
  | { type: 'D'; status: { code: number; message: string; timestamp: Date } };
  // Imagine 20 more of these...

function handle(input: LargeUnion) {}

// Passing an object that partially matches several members causes a massive explanation
handle({ 
  type: 'A', 
  data: { x: 10, y: 20, label: "Test", visible: "yes" } // 'yes' should be boolean
});
