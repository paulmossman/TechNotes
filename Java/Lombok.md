# Lombok

Never write another getter or equals method again, with one annotation your class has a fully featured builder, Automate your logging variables, and much more.

## General

Class annotation @Value is a shortcut for:
- @Getter
- @FieldDefaults(makeFinal = true, level = AccessLevel.PRIVATE)
- @AllArgsConstructor
- @EqualsAndHashCode
- @ToString

Also useful: @Builder, which adds __.builder()