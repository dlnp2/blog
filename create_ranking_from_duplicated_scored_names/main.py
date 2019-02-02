import numpy as np


def take_top_n(names, scores, n=3):
    """
    Take top `n` unique entries from `names` and `scores` according to `scores`.

    Parameters
    ----------
    names : list
        Input flat list. The entries must be sorted according to `scores`
        in descendent manner.
    scores : list
        Input flat list. This also must be sorted as `names`.
    n : int
        Specifies how much entries to be taken.
    Returns
    -------
    top_names : list
        The top n unique names taken from `names`
    top_scores : list
        The top n scores taken from `scores` corresopnding to `top_names`
    """
    assert len(names) == len(scores)

    # Note: np.unique sorts the output.
    _, index = np.unique(names, return_index=True)
    sort_index = np.argsort(index)
    index = index[sort_index]

    unique_names = np.array(names)[index]
    unique_scores = np.array(scores)[index]
    top_names = unique_names[:n].tolist()
    top_scores = unique_scores[:n].tolist()

    return top_names, top_scores


def test():
    names = ["hoge", "hoge", "var", "foo", "foo", "var"]
    scores = [1.0, 0.9, 0.8, 0.7, 0.6, 0.5]

    expected_names = ["hoge", "var", "foo"]
    expected_scores = [1.0, 0.8, 0.7]

    top_names, top_scores = take_top_n(names, scores, n=3)

    assert top_names == expected_names
    assert top_scores == expected_scores


if __name__ == "__main__":
    test()

