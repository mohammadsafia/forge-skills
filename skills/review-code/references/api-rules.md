# API & Handler Rules Reference

## ApiEndpoints Pattern

All endpoints declared in `src/api/config/ApiEndpoints.ts` as plain strings:

```typescript
// CORRECT — plain strings
export const ApiEndpoints = {
  USERS: {
    LIST: '/users',
    BY_ID: '/users/:id',
    CREATE: '/users',
  },
} as const;

// WRONG — function callbacks
EVENTS: {
  INDEX: () => '/calendar/events',  // NO!
}
```

## Handler Pattern

1. Define request functions ABOVE the handler object
2. `queryKey` must be a string — not an array
3. Reference functions by name — don't inline them

```typescript
import { pathBuilder } from '@utils';

// CORRECT — request functions defined above
async function getUsersList(params: UsersListParamsDto): Promise<ResultDto<UsersListDto>> {
  return HttpClient.get<ResultDto<UsersListDto>>(ApiEndpoints.USERS.LIST, { params });
}

async function getUserById(id: string): Promise<ResultDto<UserDto>> {
  return HttpClient.get<ResultDto<UserDto>>(pathBuilder(ApiEndpoints.USERS.BY_ID, { id }));
}

async function createUser(payload: UserForCreateDto): Promise<ResultDto<UserDto>> {
  return HttpClient.post<ResultDto<UserDto>>(ApiEndpoints.USERS.CREATE, payload);
}

// CORRECT — queryKey is string, request is reference
export const usersHandler = {
  getList: {
    queryKey: 'users/list',
    request: getUsersList,
  },
  getById: {
    queryKey: 'users/detail',
    request: getUserById,
  },
  create: {
    mutationKey: 'users/create',
    request: createUser,
  },
} as const;

// WRONG — array queryKey
queryKey: ['users', 'list'] as const  // NO!

// WRONG — inlined request function
request: (params) => HttpClient.get(...)  // NO!
```

## React Query Hook Patterns

Queries go in `src/lib/hooks/queries/`, mutations in `src/lib/hooks/mutations/`.

**DO NOT add explicit return types** — let TypeScript infer from handlers.

### Query Pattern
```typescript
// CORRECT — wrap string queryKey in array, no explicit return type
export const useUsersQuery = (enabled = true) => {
  return useQuery({
    queryKey: [usersHandler.getList.queryKey],
    queryFn: () => usersHandler.getList.request(),
    enabled,
  });
};

// CORRECT — parameterized query
export const useUserByIdQuery = (id: string, enabled = true) => {
  return useQuery({
    queryKey: [usersHandler.getById.queryKey, id],
    queryFn: () => usersHandler.getById.request(id),
    enabled: enabled && !!id,
  });
};

// WRONG — explicit return type
export const useUsersQuery = (enabled = true): UseQueryResult<...> => { ... }
```

### Mutation Pattern
```typescript
// CORRECT — no return type, invalidate on success, handle errors with toast
export const useCreateUserMutation = () => {
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { t } = useAppTranslation('users');

  return useMutation({
    mutationKey: [usersHandler.create.mutationKey],
    mutationFn: (data) => usersHandler.create.request(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [usersHandler.getList.queryKey] });
      toast({ title: t('created_successfully'), variant: 'success' });
    },
    onError: (error) => {
      toast({ title: error.message, variant: 'destructive' });
    },
  });
};
```

### Mutation Rules
- Use centralized `mutationKey` from handler
- Invalidate correct queries after success
- Handle errors in `onError` with toast notifications — never silently swallow
- No duplicated server state: never copy React Query data into `useState`

## React Query Defaults

| Setting | Value |
|---------|-------|
| `staleTime` | 5 minutes |
| `gcTime` | 10 minutes |
| `retry` | 1 |
| `refetchOnWindowFocus` | false |

## State Management

| State Type | Solution |
|------------|----------|
| Local UI state | `useState` |
| Server state | React Query |
| Global UI state | Context (Auth, Theme, Products, Bookmarks) |
| URL state | nuqs |

**Critical rule**: Never duplicate React Query state into `useState`. Use the query result directly:

```typescript
// CORRECT — use query data directly
const usersQuery = useUsersQuery();
const filteredUsers = useMemo(() => usersQuery.data?.filter(...), [usersQuery.data]);

// WRONG — duplicating server state into useState
const usersQuery = useUsersQuery();
const [userList, setUserList] = useState(usersQuery.data); // NO!
useEffect(() => setUserList(usersQuery.data), [usersQuery.data]); // NO!
```

## Error Handling

- Type error responses using the existing `ApiError` type
- Handle errors in mutation `onError` callbacks with toast notifications
- Never silently swallow errors — always surface via toast or error UI

```typescript
// CORRECT
onError: (error) => {
  toast({ variant: 'destructive', title: error.message });
},

// WRONG — silent failure
onError: () => {},
onError: (error) => console.log(error),
```

## Integration Checklist

Every new BE endpoint requires:
1. Endpoint string in `ApiEndpoints.ts`
2. DTOs in `src/types/api/` (ForReadDto, ForCreateDto, ParamsDto, etc.)
3. DTOs exported through barrel `index.ts`
4. Handler in `src/api/handlers/` with typed request functions + handler object
5. React Query hook in `src/lib/hooks/queries/` or `mutations/`
6. Hook wired into page/view
