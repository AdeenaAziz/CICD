# Containerize the go application that we have created
# This is the Dockerfile that we will use to build the image
# and run the container

# Start with a base image
FROM golang:1.22.5 As base

# Set the working directory inside the container, for the dockerimage, all comand that we
#will write after this will be implemented in this work directory.
#Docker container ke andar ab hum /app directory ke andar kaam kar rahe hain
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory, dependecies are stored here
COPY go.mod ./

# Download all the dependencies, it dl the dependencies for application
RUN go mod download

# Copy the source code to the working directory
COPY . .

# Build the application, here we do not need to mention app/main, reason being we are already in the app directory.
#here, an artifact called as main , or binary called as main will be created in the docker images

RUN go build -o main .

#######################################################
# Reduce the image size using multi-stage builds
# We will use a distroless image to run the application
#Mujhe Go compiler ki zarurat nahi hai. Application already compile ho chuki hai. Mujhe sirf application RUN karni hai
FROM gcr.io/distroless/base

# Copy the binary from the previous stage
COPY --from=base /app/main .

# Copy the static files from the previous stage
COPY --from=base /app/static ./static

# Expose the port on which the application will run
#⚠️ EXPOSE 8080 port ko automatically laptop par publish nahi karta.
#For example, container run karte waqt:
#docker run -p 8080:8080 image-name
#karna padega.
EXPOSE 8080

# Command to run the application
CMD ["./main"]
