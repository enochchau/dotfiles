type Action = 
  | { type: "CREATE_USER"; payload: { name: string; age: number; email: string } }
  | { type: "DELETE_USER"; payload: { id: string; reason: string } }
  | { type: "UPDATE_USER"; payload: { id: string; changes: { email?: string; age?: number } } }
  | { type: "LOGIN_USER"; payload: { token: string; expires: number } };

function handleAction(action: Action) {
  console.log(action);
}

// ERROR: Missing multiple required fields and using a wrong 'type'
handleAction({
  type: "UPDAT_USER", // Typo here
  payload: {
    name: "John",
    id: 123 // Wrong type (number instead of string)
  }
});
