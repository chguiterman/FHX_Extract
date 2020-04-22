# Extract metadata from FHX file

extract_rings_meta <- function(x) {

    tree_out <- data.frame(
    first_year = first_year(x),
    last_year = last_year(x)
    )
  comp <- composite(x, filter_prop = 0, 
                    filter_min_rec = 0,
                    filter_min_events = 0)
  comp_out <- data.frame(first_scar = NA, last_scar = NA)
  if (length(get_event_years(comp)[[1]]) > 0){
    comp_out$first_scar = min(get_event_years(comp)[[1]])
    comp_out$last_scar = max(get_event_years(comp)[[1]])
  }
  out <- cbind(tree_out, comp_out,
               number_of_trees = length(series_names(x)))
  out
}
