CXX := g++
CXXFLAGS := -std=c++20 -Wall -Wextra -O2
LDFLAGS :=

SRC_DIR := src
LIB_DIR := lib
BUILD_DIR := build

SRCS := $(wildcard $(SRC_DIR)/*.cpp) $(wildcard $(LIB_DIR)/src/*.cpp)
OBJS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(notdir $(SRCS)))

TARGET := $(BUILD_DIR)/Argument_search

.PHONY: all clean help run

all: $(TARGET)

$(TARGET): $(OBJS)
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# $(BUILD_DIR)/%.o: $(LIB_DIR)/src/%.cpp
# 	@mkdir -p $(@D)
# 	$(CXX) $(CXXFLAGS) -I$(LIB_DIR)/include -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)

run: $(TARGET)
	@$(TARGET) ${ARGS}

help:
	@echo "Usage:"
	@echo "  make         # Build the project"
	@echo "  make run     # Build and run the project"
	@echo "  make clean   # Remove build artifacts"
	@echo "  make help    # Show this help message"
	@echo ""
	@echo "Current settings:"
	@echo "  CXX        = $(CXX)"
	@echo "  CXXFLAGS   = $(CXXFLAGS)"

print-%:
	@echo $* = $($*)
