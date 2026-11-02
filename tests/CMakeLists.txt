find_package(Qt6Test ${QT_MIN_VERSION} REQUIRED)

add_executable(test_kgenmoji test_kgenmoji.cpp)
target_compile_definitions(test_kgenmoji PRIVATE KGENMOJI_SOURCE_DIR="${CMAKE_SOURCE_DIR}")
target_link_libraries(test_kgenmoji PRIVATE
    kgenmoji_core
    Qt6::Core
    Qt6::Test
)

add_test(NAME test_kgenmoji COMMAND test_kgenmoji)
