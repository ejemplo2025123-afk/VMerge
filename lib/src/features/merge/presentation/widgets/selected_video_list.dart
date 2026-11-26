// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/merge_page.dart';

class _SelectedVideoList extends StatelessWidget {
  const _SelectedVideoList({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenWidth / 4,
      child: BlocBuilder<MergePageCubit, MergePageState>(
        builder: (context, state) {
          switch (state) {
            case MergePageInitial():
              return const SizedBox.shrink();
            case MergePageLoading():
              return const Center(
                child: CircularProgressIndicator(),
              );
            case MergePageLoaded():
              return ReorderableListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                buildDefaultDragHandles: false,
                itemCount: state.videoMetadatas.length,
                onReorder: (oldIndex, newIndex) {
                  context
                      .read<MergePageCubit>()
                      .reorderVideos(oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final metadata = state.videoMetadatas[index];
                  final keyValue =
                      '${metadata.file?.path ?? metadata.title}-$index';

                  return SizedBox(
                    key: ValueKey<String>(keyValue),
                    width: context.screenWidth / 4,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _VideoThumbnail(
                          animation: animation,
                          index: index.clamp(0, 3),
                          metadata: metadata,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton.filledTonal(
                            tooltip: 'Remove video',
                            visualDensity: VisualDensity.compact,
                            onPressed: state.videoMetadatas.length > 2
                                ? () {
                                    context
                                        .read<MergePageCubit>()
                                        .removeVideoAt(index);
                                  }
                                : null,
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: ReorderableDragStartListener(
                            index: index,
                            child: Material(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              shape: const CircleBorder(),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.drag_handle_rounded),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            case MergePageError():
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
