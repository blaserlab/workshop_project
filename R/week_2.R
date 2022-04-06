# read in an example data file
# or substitute a file path to your own data
read_csv(file = "https://raw.githubusercontent.com/blaserlab/datascience.curriculum/main/inst/extdata/demo_iris_data.csv")

read_csv(file = "https://raw.githubusercontent.com/blaserlab/datascience.curriculum/main/inst/extdata/demo_iris_data.csv", col_types = "fddddc")

# assign the data to the variable, demo_data
# readr::read_csv(file = system.file("extdata/demo_iris_data.csv", package = "datascience.curriculum"))
demo_data <- read_csv(file = "https://raw.githubusercontent.com/blaserlab/datascience.curriculum/main/inst/extdata/demo_iris_data.csv", col_types = "fddddc")
demo_data

# a numeric vector
c(1, 2, 3)

# a character vector
c("a", "b", "c")

# another character vector
c("1", "b" ,"charlie")

# here 1 gets coerced to a character because a vector must be all the same type
# c() creates a vector
# list() creates a list

c(1, "b", "charlie")

# extract a column by position
# the head command prints the first few values only
# omit head() if you want the whole thing
head(demo_data[[2]])

# extract a column by name
head(demo_data[["Species"]])

# another way to extract a column by name
# most important to remember!!
head(demo_data$Species)


# subset using dataframe[row,colum] syntax
# subset a dataframe to get the second and third columns only
demo_data[,2:3]

# subset a dataframe to get the first and second rows only
demo_data[1:2,]

# subset to include columns by name
demo_data[c("Species", "observation")]

# subset a list to return a smaller list

demo_list <- list(1, "b", "charlie")

demo_list


# optionally name the elements
names(demo_list) <- c("a_number", "a_letter", "a_name")

# extract the elements by name
demo_list$a_number
demo_list$a_letter
demo_list$a_name


# return the first two elements
demo_list[1:2]

# subset a list by name
demo_list["a_name"]



# get the mean of the sepal length
mean(demo_data$Sepal.Length)

# add two vectors
c(1, 2) + c(2, 3)

# for vectors of unequal length, the smaller vector is "recycled" for each element of the larger vector
1 + c(1, 2, 3)

# this gives a warning if the recycling doesn't work out evenly
c(1, 2) + c(1, 2, 3)

# logical tests return boolean values

1 > 0

2 == 2

1 != 3

2 <= 1

# add a new column with mutate
# then group by a useful categorical variable
# then summarize the new value we calculated by mean according to group
demo_data |>
  mutate(sepal_l_w = Sepal.Length + Sepal.Width) |>
  group_by(Species) |>
  summarise(mean_sepal_l_w = mean(sepal_l_w))

# return a tibble without the observation column
demo_data |>
  select(-observation)

# return a tibble with only the Species and Sepal.Length columns
demo_data |>
  select(c(Species, Sepal.Length))

# filter rows satisfying a logical test
demo_data |>
  filter(Species == "setosa")

demo_data |>
  filter(Species %in% c("setosa", "versicolor"))

# pivot from wide form to long form
long_data <- demo_data |>
  pivot_longer(cols = c(Sepal.Length,  Sepal.Width, Petal.Length, Petal.Width))
long_data

# pivot back to wide form
long_data |>
  pivot_wider(names_from = "name", values_from = "value")

# make two smaller tables
sepal_data <-
  demo_data |>
  group_by(Species) |>
  summarise(mean_sepal_l = mean(Sepal.Length), mean_sepal_w = mean(Sepal.Width))
sepal_data

petal_data <-
  demo_data |>
  group_by(Species) |>
  summarise(mean_petal_l = mean(Petal.Length), mean_petal_w = mean(Petal.Width))
petal_data

# now join them back together
left_join(sepal_data, petal_data)
