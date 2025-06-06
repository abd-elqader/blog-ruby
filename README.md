# Blog API with Authentication

A Rails API application that provides user authentication, post management with tags and comments, and scheduled post deletion.

## Features

- User authentication with JWT
- CRUD operations for Posts
- Post comments functionality
- Post tagging system
- Automatic post deletion after 24 hours using Sidekiq
- Image upload for user profiles
- Comprehensive test suite

## Tech Stack

- Ruby on Rails 8.0.2 API
- PostgreSQL database
- Redis for Sidekiq background processing
- Docker containerization
- JWT authentication
- Active Storage for image uploads
- RSpec for testing

## Requirements

- Docker and Docker Compose

## Getting Started

### Running the application

1. Clone the repository:
```bash
git clone <repository-url>
cd blog-ruby
```

2. Start the application using Docker Compose:
```bash
docker-compose up
```

This will start:
- Rails API server on port 3000
- PostgreSQL database on port 5432
- Redis server on port 6379
- Sidekiq worker

### API Endpoints

#### Authentication
- `POST /auth/register` - Register a new user
- `POST /auth/login` - Login and get JWT token

#### Posts
- `GET /posts` - List all posts
- `GET /posts/:id` - Get a specific post
- `POST /posts` - Create a new post (requires authentication)
- `PUT /posts/:id` - Update a post (only by author)
- `DELETE /posts/:id` - Delete a post (only by author)

#### Comments
- `GET /posts/:post_id/comments` - List comments for a post
- `GET /posts/:post_id/comments/:id` - Get a specific comment
- `POST /posts/:post_id/comments` - Create a comment on a post (requires authentication)
- `PUT /posts/:post_id/comments/:id` - Update a comment (only by author)
- `DELETE /posts/:post_id/comments/:id` - Delete a comment (only by author)

#### User Profile
- `GET /profile` - Get current user profile (requires authentication)

### API Usage Examples

#### User Registration
```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }'
```

#### User Login
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

#### Create a Post (with JWT token)
```bash
curl -X POST http://localhost:3000/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "post": {
      "title": "My First Post",
      "body": "This is the content of my first blog post."
    },
    "tags": ["technology", "programming"]
  }'
```

#### Get All Posts
```bash
curl -X GET http://localhost:3000/posts \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

#### Add a Comment to a Post
```bash
curl -X POST http://localhost:3000/posts/1/comments \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "comment": {
      "body": "Great post! Thanks for sharing."
    }
  }'
```

## Data Models

### User
- `id` (integer, primary key)
- `name` (string, required)
- `email` (string, required, unique)
- `password_digest` (string, required)
- `created_at` (datetime)
- `updated_at` (datetime)
- `image` (Active Storage attachment)

### Post
- `id` (integer, primary key)
- `title` (string, required)
- `body` (text, required)
- `author_id` (integer, foreign key to users)
- `created_at` (datetime)
- `updated_at` (datetime)

### Comment
- `id` (integer, primary key)
- `body` (text, required)
- `post_id` (integer, foreign key to posts)
- `author_id` (integer, foreign key to users)
- `created_at` (datetime)
- `updated_at` (datetime)

### Tag
- `id` (integer, primary key)
- `name` (string, required, unique)
- `created_at` (datetime)
- `updated_at` (datetime)

### PostTag (Join Table)
- `id` (integer, primary key)
- `post_id` (integer, foreign key to posts)
- `tag_id` (integer, foreign key to tags)
- `created_at` (datetime)
- `updated_at` (datetime)

## Authentication

The API uses JWT (JSON Web Tokens) for authentication. After successful registration or login, you'll receive a token that should be included in the `Authorization` header as a Bearer token for all authenticated requests.

**Example:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2OTk5OTk5OTl9...
```

## Background Jobs

The application uses Sidekiq for background processing:

- **Post Deletion Job**: Automatically deletes posts 24 hours after creation
- Jobs are stored in Redis and processed by Sidekiq workers

## Validations and Business Rules

### User Validations
- Name is required
- Email is required and must be unique (case-insensitive)
- Password is required and must be at least 6 characters
- Email must be in valid format

### Post Validations
- Title is required
- Body is required
- Must have at least one tag
- Author can only edit/delete their own posts

### Comment Validations
- Body is required
- Author can only edit/delete their own comments

### Security Features
- JWT token-based authentication
- Password hashing with bcrypt
- User authorization for CRUD operations
- CORS configuration for cross-origin requests

## License

This project is licensed under the MIT License.